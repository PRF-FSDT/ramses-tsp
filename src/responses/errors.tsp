using TypeSpec.Http;

namespace RamsesService;

@error
model NotFoundError {
  @statusCode statusCode: 404;
  message: string;
}

@error
model BadRequestError {
  @statusCode statusCode: 400;
  message: string;
}

@error
model ValidationError {
  @statusCode statusCode: 422;
  message: string;
  errors: Record<string[]>;
}

@error
model InternalServerError {
  @statusCode statusCode: 500;
  message: string;
}
