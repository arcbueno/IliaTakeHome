import { Controller, Get, Post, Body, Param, Delete } from "@nestjs/common";
import { UsersService } from "./users.service";
import { CreateUserDto } from "./dto/create-user.dto";
import { ApiOperation, ApiResponse } from "@nestjs/swagger";

@Controller("users")
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Post()
  @ApiOperation({ summary: "Cria um novo usuário" })
  @ApiResponse({ status: 201, description: "Usuário criado com sucesso." })
  @ApiResponse({ status: 409, description: "Email já cadastrado." })
  create(@Body() createUserDto: CreateUserDto) {
    return this.usersService.create(createUserDto);
  }

  @Get()
  @ApiOperation({ summary: "Lista todos os usuários" })
  @ApiResponse({ status: 200, description: "Lista retornada com sucesso." })
  findAll() {
    return this.usersService.findAll();
  }

  @Delete(":id")
  @ApiOperation({ summary: "Remove um usuário por ID" })
  @ApiResponse({ status: 200, description: "Usuário removido com sucesso." })
  @ApiResponse({ status: 404, description: "Usuário não encontrado." })
  remove(@Param("id") id: string) {
    return this.usersService.remove(id);
  }
}
