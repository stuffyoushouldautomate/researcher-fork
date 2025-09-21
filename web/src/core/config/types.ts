export interface ModelConfig {
  basic: string[];
  reasoning: string[];
}

export interface RagConfig {
  provider: string;
}

export interface BulldozerConfig {
  rag: RagConfig;
  models: ModelConfig;
}
