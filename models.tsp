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
  @key id: int64;
  no: string;
  name: string;
  description: string;
  notes: string;
  status: string;
  client_no: string;
  client_name: string;
  client_address_line1: string;
  client_street: string;
  client_street_no: string;
  client_postal_code: string;
  client_city: string;
  client_country_code: string;
  owner: string;
  responsible: string;
  employee: string;
  drawing_no: string;
  location: string;
  prod_duration_days: numeric;
  prod_start_date: string;
  transport_date: string;
  delivery_date: string;
  creation_date: string;
  created_at: string;
  updated_at: string;
  //@added(Versions.dev) ext_created_at: offsetDateTime;
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
  first?: string;
  last?: string;
  prev?: string;
  next?: string;
}

model PaginationMeta {
  current_page: int32;
  from?: int32;
  last_page: int32;
  path: string;
  per_page: int32;
  to?: int32;
  total: int32;
}

model PaginatedResponse<T> {
  data: T[];
  //links: PaginationLinks;
  //meta: PaginationMeta;
  //filters: FilterOption[]; //TODO: check if this is the best way
}

//FILTERS
model FilterOption {
  name: string;
  type: string;
  options?: Array<string> | null;
}

model FilterRequest {
  @query page?: int32;
  @query perPage?: int32;
  @query search?: string;
  @query filters?: []; //TODO: check if this is the best way 
}

  