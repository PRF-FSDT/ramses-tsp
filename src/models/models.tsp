import "@typespec/http";
import "@typespec/rest";
import "@typespec/openapi3";
import "@typespec/versioning";

using TypeSpec.Versioning;
using TypeSpec.Http;
using TypeSpec.Rest;


namespace RamsesService;

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


// Scalars: 
@pattern("\\d{4}-\\d{2}-\\d{2}")
scalar DateString extends string;

// Aliases:
alias OrderTaskType = "preparation" | "finalisation";


//MODELS:
model Client {
  client_no: string;
  client_name: string;
  client_address_line1: string;
  client_street: string;
  client_street_no: string;
  client_postal_code: string;
  client_city: string;
  client_country_code: string;
}

model Order {
  @key id: int64;
  no: string;
  name: string;
  description: string;
  notes: string;
  status: string;
  owner: string;
  responsible: string;
  employee: string;
  ...Client;
  drawing_no: string;
  location: string;
  prod_duration_days: integer;
  finalisation_duration_days: integer;
  prep_duration_days: integer;
  finalisation_date: DateString;
  created_at: string;
  updated_at: string;
  tasks?: Array<OrderTask> | null;
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
  children: OrderCompositionLine[];
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

model OrderTaskBody{
  order_no: string;
  type: OrderTaskType;
  title: string;
  should_be_planned: boolean;
  is_required_for_production: boolean;
  is_external: boolean;
  is_finished: boolean;
  dependant_on: Array<integer>;
}

model OrderTaskUpdateBody{
  type?: OrderTaskType;
  title?: string;
  should_be_planned?: boolean;
  is_required_for_production?: boolean;
  is_external?: boolean;
  is_finished?: boolean;
  dependant_on?: Array<integer>;
  duration_in_min?: numeric | null;
  planned_resource_id?: numeric | null;
  planned_start?: DateString | null;
}

model OrderTask {
  @key id: uint64;
  order_no?: string;
  type: OrderTaskType;
  title: string;
  should_be_planned: boolean;
  is_required_for_production: boolean;
  is_external?: boolean;
  is_finished?: boolean;
  finished_by?: numeric | null;
  dependant_on?: Array<numeric> | null;
  duration_in_min?: numeric | null;
  planned_resource_id?: numeric | null;
  planned_start?: DateString | null;
}

model SyncedOrder {
  @key id: string;
  name: string;
  client_no: string;
  client_name: string;
  project_manager: string;
}

model ResourceBody{
  user_id: string;
  name: string;
}

model Resource {
  @key id: string;
  ...ResourceBody;
}

model OperatingHourBody {
  day: string;
  start: string;
  end: string;
}

model ToPlanTaskBody {
  @key id: uint64;
  duration_in_min: numeric;
  planned_resource_id: numeric;
  planned_start: DateString;
}

model OperatingHour {
  @key id: int32;
  day: string;
  start: string;
  end: string;
  updated_at: string;
  created_at: string;
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
  token: string;
}

model LogoutResponse {
  message: string;
}

model MeResponse {
  name: string;
  email: string;
}

model OrderImportResponse {
  ...Order;
}
model OrderImportBody{
  synced_order_id?: string,
  name: string;
  finalisation_date: DateString;
  finalisation_duration_days?: integer;
  prod_duration_days?: integer;
  prep_duration_days?: integer;
}


model ListResponse<T> {
  @statusCode statusCode: 200;
  @body body: T[];
}

model RecordResponse<T> {
  @statusCode statusCode: 200;
  @body body: Record<T>;
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
  filters?: FilterOption[];
}

model CreatedResponse<T> {
  @statusCode statusCode: 201;
  @body body: T;
}

model UpdatedResponse<T>{
  @statusCode statusCode: 200;
  @body body: T; 
}

model DeletedResponse{
  @statusCode statusCode: 204;
}

//FILTERS
model FilterOption {
  name: string;
  type: string;
  options?: Array<string> | null;
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

model OrderIndexFilterRequest {
  ...PaginatedSortableRequest;
  @query status?: string;
  @query owner?: string;
  @query client_name?: string;
  @query finalisation_date_from?: string;
  @query finalisation_date_until?: string;
  @query include?: "tasks";
}

model OrderMaterialIndexFilterRequest {
  ...PaginatedSortableRequest;
  @query category_no?: string;
  @query stock_status?: string;
}

model OrderCompositionLineRequest {
  ...PaginatedSortableRequest;
  @query parentId?: int32;
}

model OrderTaskFilterRequest {
  ...PaginatedSortableRequest;
  @query type?: OrderTaskType;
}

model OrderMaterialCsvRequest {
  @query excludeRunningMeterParts?: boolean;
  @query excludeSheetMaterials?: boolean;
  @query excludePurchaseParts?: boolean;
  @query excludeFittings?: boolean;
  @query excludeEdging?: boolean;
}

