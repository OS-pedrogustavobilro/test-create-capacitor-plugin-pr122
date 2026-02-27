export interface CapacitorKotlinPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}
