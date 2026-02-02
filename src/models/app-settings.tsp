model AppSetting {
  post_panel_consumption_to_erp: boolean;
  use_sorting_locations: boolean;
  default_whse_location_code: string;
  default_prod_duration_days: numeric;
  default_finalisation_duration_days: numeric;
}

model AppSettingBody {
  post_panel_consumption_to_erp?: boolean;
  use_sorting_locations?: boolean;
  default_whse_location_code?: string;
  default_prod_duration_days?: numeric;
  default_finalisation_duration_days?: numeric;
}
