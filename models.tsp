import "@typespec/http";
import "@typespec/rest";
import "@typespec/openapi3";
import "@typespec/versioning";

using TypeSpec.Versioning;
using TypeSpec.Http;
using TypeSpec.Rest;


@versioned(Versions)
@service({
  title: "RAMSES",
})

namespace RamsesService;

enum Versions {
  v1,
  dev,
}

//MODELS:
model Order {
  @key id: string;
  name: string;
  client_no: string;
  client_name: string;
  project_manager: string;
  status: string;
  @added(Versions.dev) ext_created_at: offsetDateTime;
}

model OrderAttachment {
  @key id: string;
  order_no: string;
  type: string;
  path: string;
}

//TODO: extend
model OrderCompositionLine {
  @key id: uint64;
  order_no: string;
}

//TODO: extend
model AdditionalPurchaseLine {
  @key id: uint64;
  order_no: string;
}

model OrderMaterial {
  @key id: string;
  order_no: string;
  material_no: string;
  material_name: string;
  brutto_qty_m2: float32;
  netto_qty_m2: float32;
  orderMaterialItems: OrderMaterialItem[];
}

model OrderMaterialItem {
  @key id: string;
  order_no: string;
  material_no: string;
  item_no: string;
  qty_calculated: uint16;
  user_qty: uint16;
}

model SyncedOrder {
  @key id: string;
  name: string;
  client_no: string;
  client_name: string;
  project_manager: string;
}

//RESPONSES:
@error
model Error {
  code: int32;
  message: string;
}

//AUTH
model LoginResponse {
  token: string
}

model LogoutResponse {
  message: string
}

model MeResponse {
  name: string,
  email: string
}

//PAGINATION:
model PaginationLinks {
  first: string;
  last: string;
  prev?: string;
  next?: string;
}

model PaginationMeta {
  current_page: int32;
  from: int32;
  last_page: int32;
  path: string;
  per_page: int32;
  to: int32;
  total: int32;
}

model PaginatedResponse<T> {
  data: T[];
  links: PaginationLinks;
  meta: PaginationMeta;
  filters: FilterOption[]; //TODO: check if this is the best way
}

//FILTERS
model FilterOption {
  name: string;
  type: "checkbox" | "daterange";
  options?: Array<string>;
}

model FilterRequest {
  @query page?: int32;
  @query perPage?: int32;
  @query search?: string;
  @query filters?: []; //TODO: check if this is the best way 
}

  