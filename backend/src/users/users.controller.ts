import { Controller, Get, Post, Body, Param, Delete } from "@nestjs/common";
import { UsersService } from "./users.service";
import { CreateUserDto } from "./dto/create-user.dto";
import { ApiOperation, ApiResponse } from "@nestjs/swagger";

@Controller("users")
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Post()
  @ApiOperation({ summary: "Create a new user" })
  @ApiResponse({ status: 201, description: "User created successfully." })
  @ApiResponse({ status: 409, description: "Email already registered." })
  create(@Body() createUserDto: CreateUserDto) {
    return this.usersService.create(createUserDto);
  }

  @Get()
  @ApiOperation({ summary: "List all users" })
  @ApiResponse({ status: 200, description: "List returned successfully." })
  findAll() {
    return this.usersService.findAll();
  }

  @Delete(":id")
  @ApiOperation({ summary: "Remove a user by ID" })
  @ApiResponse({ status: 200, description: "User removed successfully." })
  @ApiResponse({ status: 404, description: "User not found." })
  remove(@Param("id") id: string) {
    return this.usersService.remove(id);
  }
}
