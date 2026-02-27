export interface CapacitorJavaPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}
