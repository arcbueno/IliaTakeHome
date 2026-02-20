import { User } from "../schemas/user.schema";

export class UserResponseDto {
  id: string;
  name: string;
  email: string;
  phone?: string;
}

export class UserMapper {
  static toDto(user: User & { _id: any }): UserResponseDto {
    return {
      id: user._id.toString(),
      name: user.name,
      email: user.email,
      phone: user.phone,
    };
  }

  static toDtoList(users: (User & { _id: any })[]): UserResponseDto[] {
    return users.map((user) => this.toDto(user));
  }
}
