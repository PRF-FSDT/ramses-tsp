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

model OrderCompositionLine {
  @key id: uint64;
  parent_id?: uint64 | null;
  order_id: uint64;
  order_no: string;
  no: string;
  type: string;
  ref?: string | null;
  part_no?: string | null;
  description?: string | null;
  destination?: string | null;
  length_mm?: numeric | null;
  width_mm?: numeric | null;
  height_mm?: numeric | null;
  surf_m2?: numeric | null;
  qty?: uint64 | null;
  material_no: string;
  is_outsourced: boolean;
  children: OrderCompositionLine[]
}

model AdditionalPurchaseLine {
  @key id: uint64;
  order_no: string;
  material_no: string;
  erp_no?: string | null;
  imos_no?: string | null;
  name: string;
  brand?: string | null;
  type?: string | null;
  category_no?: string | null;
  description?: string | null;
  qty: numeric;
  uom: string;
  length_mm?: numeric | null;
  width_mm?: numeric | null;
  height_mm?: numeric | null;
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
model SuccessResponse {
  message: string;
}

model StreamedCsvResponse {
  //stream
}

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
  from?: int32 | null;
  last_page: int32;
  path: string;
  per_page: int32;
  to?: int32 | null;
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

model OrderMaterialCsvRequest {
  @query excludeRunningMeterParts?: boolean;
  @query excludeSheetMaterials?: boolean;
  @query excludePurchaseParts?: boolean;
  @query excludeFittings?: boolean;
  @query excludeEdging?: boolean;
}

  