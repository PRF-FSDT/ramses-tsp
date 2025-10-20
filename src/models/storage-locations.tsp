model StorageLocation {
  @key id: int64;
  no: string;
  reserved_for: string | null;
  status: string;
  scan_code: string | null;
  last_supplied_by: string | null;
  qty_required: numeric;
  qty_received: numeric;
}

model StorageLocationBody {
  no: string;
  reserved_for?: string | null;
  status?: string;
  scan_code: string | null;
  last_supplied_by?: string | null;
  qty_required?: numeric;
  qty_received?: numeric;
}
