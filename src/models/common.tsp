import "@typespec/http";
import "@typespec/rest";
import "@typespec/openapi3";
import "@typespec/versioning";

using TypeSpec.Versioning;
using TypeSpec.Http;
using TypeSpec.Rest;

enum Versions {
  v1,
  dev,
}
enum DayOfWeek {
  Mon,
  Tue,
  Wed,
  Thu,
  Fri,
  Sat,
  Sun,
}

model PaginatedRequest {
  @query page?: int32;
  @query perPage?: int32;
  @query search?: string;
}

model PaginatedSortableRequest {
  ...PaginatedRequest;
  @query sort_dir?: "asc" | "desc";
  @query sort_by?: string;
}

@error
model Error {
  code: int32;
  message: string;
}
