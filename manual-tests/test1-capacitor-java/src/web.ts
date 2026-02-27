import { WebPlugin } from '@capacitor/core';

import type { CapacitorJavaPlugin } from './definitions';

export class CapacitorJavaWeb extends WebPlugin implements CapacitorJavaPlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}
