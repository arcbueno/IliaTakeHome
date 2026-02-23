import { IsEmail, IsNotEmpty, IsOptional, IsString } from "class-validator";
import { ApiProperty } from "@nestjs/swagger";

export class CreateUserDto {
  @ApiProperty({
    description: " The name of the user.",
    example: "John Doe",
  })
  @IsString({ message: "Name must be a valid string." })
  @IsNotEmpty({ message: "Name is required." })
  name: string;

  @ApiProperty({
    description: "The email of the user.",
    example: "test@example.com",
  })
  @IsEmail({}, { message: "Invalid email provided." })
  @IsNotEmpty({ message: "Email is required." })
  email: string;

  @ApiProperty({
    description: "The phone of the user.",
    example: "+1 555 1234",
  })
  @IsString({ message: "Phone must be a valid string." })
  @IsOptional()
  phone?: string;
}
