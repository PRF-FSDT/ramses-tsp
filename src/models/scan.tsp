model Scan {
  id: numeric;
  event_id: string;
  value: string;
  device_no: string;
  linked_mc: string;
  is_processed: boolean;
  error_message: string;
  scanned_at: string;
}

model ScanBody {
  timestamp: string;
  scancode: string;
  mc: string;
}