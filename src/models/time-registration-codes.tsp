model TimeRegistrationCode {
  @key id: int32;
  title: string;
}

model TimeRegistrationCodeBody {
  title: TimeRegistrationCode.title;
}