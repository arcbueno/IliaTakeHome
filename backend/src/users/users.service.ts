import {
  ConflictException,
  Injectable,
  NotFoundException,
} from "@nestjs/common";
import { CreateUserDto } from "./dto/create-user.dto";
import { User, UserDocument } from "./schemas/user.schema";
import { Model } from "mongoose";
import { InjectModel } from "@nestjs/mongoose/dist/common/mongoose.decorators";
import { UserMapper, UserResponseDto } from "./mappers/user.mapper";

@Injectable()
export class UsersService {
  constructor(@InjectModel(User.name) private userModel: Model<UserDocument>) {}
  async create(createUserDto: CreateUserDto): Promise<UserResponseDto> {
    const emailExists = await this.userModel.findOne({
      email: createUserDto.email,
    });

    if (emailExists) {
      throw new ConflictException("User with this email already exists");
    }

    const createdUser = new this.userModel(createUserDto);
    const savedUser = await createdUser.save();
    return UserMapper.toDto(savedUser);
  }

  async findAll(): Promise<UserResponseDto[]> {
    const users = await this.userModel.find().exec();
    return UserMapper.toDtoList(users);
  }

  async remove(id: string): Promise<UserResponseDto> {
    const deletedUser = await this.userModel.findByIdAndDelete(id).exec();
    if (!deletedUser) {
      throw new NotFoundException("User not found");
    }
    return UserMapper.toDto(deletedUser);
  }
}
