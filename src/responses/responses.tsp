import "./errors.tsp";

using TypeSpec.Http;

namespace RamsesService;

model PaginationLinks {
  first?: string | null;
  last?: string | null;
  prev?: string | null;
  next?: string | null;
}

model PaginationMeta {
  current_page: int32;
  from: int32 | null;
  last_page: int32;
  path: string;
  per_page: int32;
  to: int32 | null;
  total: int32;
}

model FilterOption {
  name: string;
  type: string;
  options?: Array<string> | null;
}

model PaginatedReturn<T> {
  data: T[];
  links: PaginationLinks;
  meta: PaginationMeta;
  filters?: FilterOption[];
}

model ActionReturn {
  @statusCode statusCode: 200;
}

model RecordReturn<T> {
  @statusCode statusCode: 200;
  @body body: Record<T>;
}

model CreatedReturn<T> {
  @statusCode statusCode: 201;
  @body body: T;
}

model UpdatedReturn<T> {
  @statusCode statusCode: 200;
  @body body: T;
}

model DeletedReturn {
  @statusCode statusCode: 204;
}

alias ListResponse<T> = Array<T> | ValidationError;
alias PaginatedResponse<T> = PaginatedReturn<T> | NotFoundError;
alias CreatedResponse<T> = CreatedReturn<T> | ValidationError;
alias UpdatedResponse<T> = UpdatedReturn<T> | ValidationError;
alias DeletedResponse = DeletedReturn;
alias RecordResponse<T> = RecordReturn<T> | NotFoundError;
alias ReadResponse<T> = T | NotFoundError;
alias ActionResponse = ActionReturn | NotFoundError;
