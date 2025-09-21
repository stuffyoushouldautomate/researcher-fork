// Copyright (c) 2025 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

import { BadgeInfo } from "lucide-react";

import { Markdown } from "~/components/deer-flow/markdown";

import aboutEn from "./about-en.md";
import type { Tab } from "./types";

export const AboutTab: Tab = () => {
  const aboutContent = aboutEn;

  return <Markdown>{aboutContent}</Markdown>;
};
AboutTab.icon = BadgeInfo;
AboutTab.displayName = "About";
