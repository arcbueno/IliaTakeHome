import { Test, TestingModule } from "@nestjs/testing";
import { UsersService } from "./users.service";
import { getModelToken } from "@nestjs/mongoose";
import { User } from "./schemas/user.schema";
import { ConflictException } from "@nestjs/common";
import { Model } from "mongoose";

describe("UsersService", () => {
  let sut: UsersService;

  // Mock Type Definition for Intellisense
  type MockModel = Model<User> & {
    create: jest.Mock;
    findOne: jest.Mock;
    find: jest.Mock;
    findOneAndDelete: jest.Mock;
    findByIdAndDelete: jest.Mock;
    constructor: jest.Mock;
  };

  let model: MockModel;

  // Mock of the "saved" document (instance)
  const mockUserInstance = {
    save: jest.fn(),
  };

  // Mock of the Model Class (constructor and statics)
  const mockUserModel = jest
    .fn()
    .mockImplementation(() => mockUserInstance) as unknown as MockModel;

  // Add static methods to the Model mock
  mockUserModel.findOne = jest.fn();
  mockUserModel.find = jest.fn();
  mockUserModel.findOneAndDelete = jest.fn();
  mockUserModel.findByIdAndDelete = jest.fn();

  // Helper function to create the SUT (System Under Test) instance
  const makeSut = async (): Promise<{
    sut: UsersService;
    model: MockModel;
  }> => {
    jest.clearAllMocks(); // Clear previous calls

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        UsersService,
        {
          provide: getModelToken(User.name),
          useValue: mockUserModel,
        },
      ],
    }).compile();

    const sut = module.get<UsersService>(UsersService);
    const model = module.get<MockModel>(getModelToken(User.name));

    return { sut, model };
  };

  beforeEach(async () => {
    const context = await makeSut();
    sut = context.sut;
    model = context.model;
  });

  describe("create", () => {
    it("should create a new user successfully", async () => {
      // Arrange
      const createUserDto = {
        name: "Test User",
        email: "test@example.com",
      };

      // Mock findOne to return null (not found)
      model.findOne.mockReturnValue(null);

      mockUserInstance.save.mockResolvedValue({
        _id: "some-id",
        ...createUserDto,
      });

      // Act
      const result = await sut.create(createUserDto);

      // Assert
      expect(model.findOne).toHaveBeenCalledWith({
        email: createUserDto.email,
      });
      expect(mockUserModel).toHaveBeenCalledWith(createUserDto); // Check constructor call
      expect(mockUserInstance.save).toHaveBeenCalled();
      expect(result).toEqual({
        id: "some-id",
        name: createUserDto.name,
        email: createUserDto.email,
      });
    });

    it("should throw ConflictException if email already exists", async () => {
      // Arrange
      const createUserDto = { name: "Test", email: "exist@test.com" };

      // Mock findOne to return existing user
      (model.findOne as jest.Mock).mockResolvedValue({
        _id: "123",
        email: "exist@test.com",
      });

      // Act & Assert
      await expect(sut.create(createUserDto)).rejects.toThrow(
        ConflictException,
      );
    });
  });

  describe("findAll", () => {
    it("should return an array of users", async () => {
      // Arrange
      const users = [
        { _id: "1", name: "User 1", email: "u1@test.com" },
        { _id: "2", name: "User 2", email: "u2@test.com" },
      ];

      model.find.mockReturnValue({
        exec: jest.fn().mockResolvedValue(users),
      });

      // Act
      const result = await sut.findAll();

      // Assert
      expect(model.find).toHaveBeenCalled();
      expect(result).toHaveLength(2);
      expect(result[0].id).toBe("1");
    });
  });

  describe("remove", () => {
    it("should remove a user by id", async () => {
      // Arrange
      const id = "some-id";
      const removedUser = {
        _id: id,
        name: "Deleted User",
        email: "deleted@test.com",
      };

      (model.findByIdAndDelete as jest.Mock).mockReturnValue({
        exec: jest.fn().mockResolvedValue(removedUser),
      });

      // Act
      const result = await sut.remove(id);

      // Assert
      expect(model.findByIdAndDelete).toHaveBeenCalledWith(id);
      expect(result).toEqual({
        id: id,
        name: removedUser.name,
        email: removedUser.email,
      });
    });
  });
});
