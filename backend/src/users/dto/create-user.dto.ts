import { IsEmail, IsNotEmpty, IsOptional, IsString } from "class-validator";
import { ApiProperty } from "@nestjs/swagger";

export class CreateUserDto {
  @ApiProperty({
    description: "O nome do usuário.",
    example: "João Silva",
  })
  @IsString({ message: "O nome deve ser uma string válida." })
  @IsNotEmpty({ message: "O nome é obrigatório." })
  name: string;

  @ApiProperty({
    description: "O e-mail do usuário.",
    example: "teste@exemplo.com",
  })
  @IsEmail({}, { message: "O e-mail informado é inválido." })
  @IsNotEmpty({ message: "O e-mail é obrigatório." })
  email: string;

  @ApiProperty({
    description: "O telefone do usuário.",
    example: "+55 11 91234-5678",
    required: false,
  })
  @IsString({ message: "O telefone deve ser uma string válida." })
  @IsOptional()
  phone?: string;
}
