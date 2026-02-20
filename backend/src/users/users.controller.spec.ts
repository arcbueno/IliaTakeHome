import { Test, TestingModule } from "@nestjs/testing";
import { UsersController } from "./users.controller";
import { UsersService } from "./users.service";
import { CreateUserDto } from "./dto/create-user.dto";

describe("UsersController", () => {
  let sut: UsersController;
  let usersService: jest.Mocked<UsersService>;

  // Mock do UsersService
  const mockUsersService = {
    create: jest.fn(),
    findAll: jest.fn(),
    remove: jest.fn(),
  };

  const makeSut = async (): Promise<{
    sut: UsersController;
    usersService: jest.Mocked<UsersService>;
  }> => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [UsersController],
      providers: [
        {
          provide: UsersService,
          useValue: mockUsersService,
        },
      ],
    }).compile();

    const sut = module.get<UsersController>(UsersController);
    const usersService = module.get<UsersService>(
      UsersService,
    ) as jest.Mocked<UsersService>;

    return { sut, usersService };
  };

  beforeEach(async () => {
    jest.clearAllMocks();
    const context = await makeSut();
    sut = context.sut;
    usersService = context.usersService;
  });

  it("should be defined", () => {
    expect(sut).toBeDefined();
  });

  describe("create", () => {
    it("should create a new user successfully", async () => {
      // Arrange
      const createUserDto: CreateUserDto = {
        name: "Test User",
        email: "test@example.com",
      };
      const resultDto = { id: "some-id", ...createUserDto };
      usersService.create.mockResolvedValue(resultDto);

      // Act
      const result = await sut.create(createUserDto);

      // Assert
      expect(usersService.create).toHaveBeenCalledWith(createUserDto);
      expect(result).toEqual(resultDto);
    });
  });

  describe("findAll", () => {
    it("should return an array of users", async () => {
      // Arrange
      const users = [
        { id: "1", name: "User 1", email: "u1@test.com" },
        { id: "2", name: "User 2", email: "u2@test.com" },
      ];
      usersService.findAll.mockResolvedValue(users);

      // Act
      const result = await sut.findAll();

      // Assert
      expect(usersService.findAll).toHaveBeenCalled();
      expect(result).toEqual(users);
    });
  });

  describe("remove", () => {
    it("should remove a user by id", async () => {
      // Arrange
      const id = "some-id";
      const removedUser = {
        id,
        name: "Deleted User",
        email: "deleted@test.com",
      };
      usersService.remove.mockResolvedValue(removedUser);

      // Act
      const result = await sut.remove(id);

      // Assert
      expect(usersService.remove).toHaveBeenCalledWith(id);
      expect(result).toEqual(removedUser);
    });
  });
});
