export interface CapacitorJavaToKotlinPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}
