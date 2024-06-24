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
  parent_id?: uint64;
  order_id: uint64;
  order_no: string;
  no: string;
  type: string;
  ref?: string;
  part_no?: string;
  description?: string;
  destination?: string;
  length_mm?: numeric;
  width_mm?: numeric;
  height_mm?: numeric;
  surf_m2?: numeric;
  qty?: uint64;
  is_outsourced: boolean;
}

model AdditionalPurchaseLine {
  @key id: uint64;
  order_no: string;
  material_no: string;
  erp_no?: string;
  imos_no?: string;
  name: string;
  brand?: string;
  type?: string;
  category_no?: string;
  description?: string;
  qty: numeric;
  uom: string;
  length_mm?: numeric;
  width_mm?: numeric;
  height_mm?: numeric;
}

model OrderMaterial {
  @key id: string;
  order_no: string;
  material_no: string;
  material_name: string;
  net_qty: float32;
  gross_qty: float32;
  uom: string;
  category_no: string;
  stock_status: string;
  order_material_items: OrderMaterialItem[];
}

model OrderMaterialItem {
  @key id: string;
  order_no: string;
  material_no: string;
  material_name: string;
  item_no: string;
  item_name: string;
  net_qty: numeric;
  gross_qty: numeric;
  qty: numeric;
  uom: string;
  category_no: string;
  stock_status: string;
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
  first?: string | null;
  last?: string | null;
  prev?: string | null;
  next?: string | null;
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
  data: T[] | [];
  links: PaginationLinks;
  meta: PaginationMeta;
  filters: FilterOption[]; //TODO: check if this is the best way
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

model OrderCompositionLineRequest {
  @query page?: int32;
  @query perPage?: int32;
  @query search?: string;
  @query parentId?: int32;
}

  