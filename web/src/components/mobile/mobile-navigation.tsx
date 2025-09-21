// Copyright (c) 2025 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

"use client";

import { motion, useMotionValue, useTransform, type PanInfo } from "framer-motion";
import { ChevronLeft, MessageSquare, Search } from "lucide-react";
import { useCallback, useEffect, useState } from "react";

import { Button } from "~/components/ui/button";
import { useStore } from "~/core/store";
import { cn } from "~/lib/utils";

interface MobileNavigationProps {
  children: React.ReactNode;
  researchContent: React.ReactNode;
}

export function MobileNavigation({ children, researchContent }: MobileNavigationProps) {
  const openResearchId = useStore((state) => state.openResearchId);
  const openResearch = useStore((state) => state.openResearch);
  const [isDragging, setIsDragging] = useState(false);
  
  // Motion values for swipe gestures
  const x = useMotionValue(0);
  const opacity = useTransform(x, [-200, 0, 200], [0.3, 1, 0.3]);
  
  // Handle swipe gestures
  const handleDragEnd = useCallback((event: any, info: PanInfo) => {
    const threshold = 100;
    const velocity = info.velocity.x;
    const offset = info.offset.x;
    
    setIsDragging(false);
    
    // Swipe right to open research (if not already open)
    if (!openResearchId && (offset > threshold || velocity > 500)) {
      openResearch("swipe-research");
    }
    // Swipe left to close research (if open)
    else if (openResearchId && (offset < -threshold || velocity < -500)) {
      openResearch(null);
    }
    
    // Reset position
    x.set(0);
  }, [openResearchId, openResearch, x]);
  
  const handleDragStart = useCallback(() => {
    setIsDragging(true);
  }, []);
  
  // Reset position when research state changes
  useEffect(() => {
    x.set(0);
  }, [openResearchId, x]);
  
  return (
    <div className="relative h-full w-full overflow-hidden">
      {/* Chat View */}
      <motion.div
        className="absolute inset-0"
        style={{ x, opacity }}
        drag="x"
        dragConstraints={{ left: 0, right: 0 }}
        dragElastic={0.2}
        onDragStart={handleDragStart}
        onDragEnd={handleDragEnd}
        animate={{
          x: openResearchId ? -window.innerWidth : 0,
        }}
        transition={{
          type: "spring",
          stiffness: 300,
          damping: 30,
        }}
      >
        {children}
      </motion.div>
      
      {/* Research View */}
      <motion.div
        className="absolute inset-0"
        animate={{
          x: openResearchId ? 0 : window.innerWidth,
        }}
        transition={{
          type: "spring",
          stiffness: 300,
          damping: 30,
        }}
      >
        <div className="flex h-full flex-col">
          {/* Research Header */}
          <div className="flex h-12 items-center justify-between border-b border-border bg-background/80 backdrop-blur-md px-4">
            <Button
              variant="ghost"
              size="icon"
              onClick={() => openResearch(null)}
              className="h-8 w-8"
            >
              <ChevronLeft className="h-4 w-4" />
            </Button>
            <div className="flex items-center gap-2">
              <Search className="h-4 w-4" />
              <span className="text-sm font-medium">Research</span>
            </div>
            <div className="h-8 w-8" /> {/* Spacer */}
          </div>
          
          {/* Research Content */}
          <div className="flex-1 overflow-auto">
            {researchContent}
          </div>
        </div>
      </motion.div>
      
      {/* Swipe Indicator */}
      {!openResearchId && (
        <motion.div
          className="absolute bottom-20 left-1/2 -translate-x-1/2 pointer-events-none"
          initial={{ opacity: 0 }}
          animate={{ opacity: 0.6 }}
          transition={{ delay: 2 }}
        >
          <div className="flex items-center gap-2 rounded-full bg-background/80 px-3 py-1 text-xs text-muted-foreground backdrop-blur-md">
            <div className="flex gap-1">
              <div className="h-1 w-1 rounded-full bg-current" />
              <div className="h-1 w-1 rounded-full bg-current" />
              <div className="h-1 w-1 rounded-full bg-current" />
            </div>
            <span>Swipe right for research</span>
          </div>
        </motion.div>
      )}
      
      {/* Bottom Navigation */}
      <div className="absolute bottom-0 left-0 right-0 flex h-16 items-center justify-center border-t border-border bg-background/80 backdrop-blur-md px-4">
        <div className="flex items-center gap-8">
          <Button
            variant={!openResearchId ? "default" : "ghost"}
            size="icon"
            className={cn(
              "h-10 w-10 rounded-full",
              !openResearchId && "bg-brand text-white"
            )}
            onClick={() => openResearch(null)}
          >
            <MessageSquare className="h-5 w-5" />
          </Button>
          
          <Button
            variant={openResearchId ? "default" : "ghost"}
            size="icon"
            className={cn(
              "h-10 w-10 rounded-full",
              openResearchId && "bg-brand text-white"
            )}
            onClick={() => openResearch(openResearchId ? null : "research")}
          >
            <Search className="h-5 w-5" />
          </Button>
        </div>
      </div>
    </div>
  );
}
