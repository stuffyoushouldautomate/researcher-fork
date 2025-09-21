// Copyright (c) 2025 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

"use client";

import { useMemo } from "react";

import { useStore } from "~/core/store";
import { useIsMobile } from "~/hooks/use-mobile";
import { cn } from "~/lib/utils";

import { MessagesBlock } from "./components/messages-block";
import { ResearchBlock } from "./components/research-block";

export default function Main() {
  const openResearchId = useStore((state) => state.openResearchId);
  const isMobile = useIsMobile();
  const doubleColumnMode = useMemo(
    () => openResearchId !== null && !isMobile,
    [openResearchId, isMobile],
  );
  
  return (
    <div
      className={cn(
        "flex h-full w-full justify-center-safe px-4 pt-12 pb-4",
        doubleColumnMode && "gap-8",
        isMobile && "px-2"
      )}
    >
      <MessagesBlock
        className={cn(
          "shrink-0 transition-all duration-300 ease-out",
          // Mobile: full width, no complex positioning
          isMobile && "w-full",
          // Desktop: original complex layout
          !isMobile && !doubleColumnMode &&
            `w-[768px] translate-x-[min(max(calc((100vw-538px)*0.75),575px)/2,960px/2)]`,
          !isMobile && doubleColumnMode && `w-[538px]`,
        )}
      />
      <ResearchBlock
        className={cn(
          "pb-4 transition-all duration-300 ease-out",
          // Mobile: hidden when not active, full screen when active
          isMobile && !openResearchId && "hidden",
          isMobile && openResearchId && "w-full",
          // Desktop: original layout
          !isMobile && "w-[min(max(calc((100vw-538px)*0.75),575px),960px)]",
          !isMobile && !doubleColumnMode && "scale-0",
        )}
        researchId={openResearchId}
      />
    </div>
  );
}
