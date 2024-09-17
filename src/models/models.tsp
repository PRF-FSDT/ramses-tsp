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
  no?: string | null;
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

  @encode(DateTimeKnownEncoding.rfc3339)
  finalisation_date: utcDateTime;

  @visibility("read")
  part_count?: int64;

  @visibility("read")
  article_count?: int64;

  created_at: string;
  updated_at: string;
  tasks?: Array<OrderTask> | null;
  plannedOrderLines: PlannedOrderLine[];
  //@added(Versions.dev) ext_created_at: offsetDateTime;
}

model UpdateOrderBody {
  name?: string;
  no?: string | null;
  description?: string;
  notes?: string;
  status?: string;
  owner?: string;
  responsible?: string;
  employee?: string;
  client_no?: string;
  client_name?: string;
  client_address_line1?: string;
  client_street?: string;
  client_street_no?: string;
  client_postal_code?: string;
  client_city?: string;
  client_country_code?: string;
  drawing_no?: string;
  location?: string;
  prod_duration_days?: integer;
  finalisation_duration_days?: integer;
  prep_duration_days?: integer;

  @encode(DateTimeKnownEncoding.rfc3339)
  finalisation_date?: utcDateTime;
}

model OrderAttachment {
  @key id: string;
  order_no: string;
  type: string;
  path: string;
}

model OrderCompositionLine {
  @key id: uint64;
  parent_id?: string | null;
  order_id: uint64;
  order_no: string;
  no: string;
  type?: uint16 | null;
  part_type?: uint16 | null;
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
  barcode?: string | null;
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
  @key id: uint64;
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

model OrderTaskBody {
  order_id: uint64;
  type: OrderTaskType;
  title: string;
  should_be_planned: boolean;
  is_required_for_production: boolean;
  is_external: boolean;
  is_finished: boolean;
  dependant_on: Array<integer>;
}

model OrderTaskUpdateBody {
  type?: OrderTaskType;
  title?: string;
  should_be_planned?: boolean;
  is_required_for_production?: boolean;
  is_external?: boolean;
  is_finished?: boolean;
  dependant_on?: Array<integer>;
  duration_in_min?: numeric | null;
  planned_resource_id?: numeric | null;

  @encode(DateTimeKnownEncoding.rfc3339)
  planned_start?: utcDateTime | null;
}

model OrderTask {
  @key id: uint64;
  order_id: integer;
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

  @encode(DateTimeKnownEncoding.rfc3339)
  planned_start?: utcDateTime | null;
}

model SyncedOrder {
  @key id: uint64;
  name: string;
  client_no: string;
  client_name: string;
  project_manager: string;
}

model ResourceBody {
  user_id: integer;
  name: string;
}

model Resource {
  @key id: uint64;
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

  @encode(DateTimeKnownEncoding.rfc3339)
  planned_start: utcDateTime;
}

model OperatingHour {
  @key id: int32;
  day: string;
  start: string;
  end: string;
  updated_at: string;
  created_at: string;
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
model OrderCreateBody {
  synced_order_no?: string | null;
  name: string;

  @encode(DateTimeKnownEncoding.rfc3339)
  finalisation_date: utcDateTime;

  finalisation_duration_days?: integer;
  prod_duration_days?: integer;
  prep_duration_days?: integer;
}

model OrderWorkflowLine {
  routing_code: string;
  qty: integer;
  run_time: float;
  setup_time: float;
  machine_center_no: string;
}

model OrderPlanBody {
  @encode(DateTimeKnownEncoding.rfc3339)
  planned_start: utcDateTime;

  routing: {
    routing_code: string;
    run_time: float;
    machine_center_no: string;
  }[];
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
