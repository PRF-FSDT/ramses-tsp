model Site {
  @key id: int32;
  name: string;
  created_at: utcDateTime;
  updated_at: utcDateTime;
}

model SiteBody {
  name: Site.name;
}
