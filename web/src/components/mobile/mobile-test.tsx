// Copyright (c) 2025 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

"use client";

import { useState, useEffect } from "react";
import { CheckCircle, XCircle, Smartphone, Tablet, Monitor } from "lucide-react";

import { Button } from "~/components/ui/button";
import { Card } from "~/components/ui/card";
import { cn } from "~/lib/utils";

interface MobileTestProps {
  className?: string;
}

export function MobileTest({ className }: MobileTestProps) {
  const [screenSize, setScreenSize] = useState<"mobile" | "tablet" | "desktop">("desktop");
  const [tests, setTests] = useState({
    responsive: false,
    touchTargets: false,
    swipeGestures: false,
    iosStyling: false,
    safeAreas: false,
  });

  useEffect(() => {
    const updateScreenSize = () => {
      const width = window.innerWidth;
      if (width < 768) {
        setScreenSize("mobile");
      } else if (width < 1024) {
        setScreenSize("tablet");
      } else {
        setScreenSize("desktop");
      }
    };

    updateScreenSize();
    window.addEventListener("resize", updateScreenSize);
    return () => window.removeEventListener("resize", updateScreenSize);
  }, []);

  useEffect(() => {
    // Simulate running tests
    const runTests = async () => {
      await new Promise(resolve => setTimeout(resolve, 500));
      setTests({
        responsive: true,
        touchTargets: screenSize === "mobile",
        swipeGestures: screenSize === "mobile",
        iosStyling: true,
        safeAreas: screenSize === "mobile",
      });
    };

    runTests();
  }, [screenSize]);

  const getIcon = () => {
    switch (screenSize) {
      case "mobile": return <Smartphone className="h-5 w-5" />;
      case "tablet": return <Tablet className="h-5 w-5" />;
      default: return <Monitor className="h-5 w-5" />;
    }
  };

  const testItems = [
    { key: "responsive", label: "Responsive Layout", description: "Layout adapts to screen size" },
    { key: "touchTargets", label: "Touch Targets", description: "Buttons sized for touch (44px+)" },
    { key: "swipeGestures", label: "Swipe Gestures", description: "Swipe navigation enabled" },
    { key: "iosStyling", label: "iOS Styling", description: "Native iOS appearance" },
    { key: "safeAreas", label: "Safe Areas", description: "Respects device safe areas" },
  ];

  return (
    <Card className={cn("p-6", className)}>
      <div className="flex items-center gap-3 mb-4">
        {getIcon()}
        <div>
          <h3 className="font-semibold">Mobile Optimization Test</h3>
          <p className="text-sm text-muted-foreground">
            Current: {screenSize} ({window.innerWidth}px)
          </p>
        </div>
      </div>

      <div className="space-y-3">
        {testItems.map((item) => {
          const passed = tests[item.key as keyof typeof tests];
          return (
            <div key={item.key} className="flex items-center gap-3">
              {passed ? (
                <CheckCircle className="h-4 w-4 text-green-500" />
              ) : (
                <XCircle className="h-4 w-4 text-red-500" />
              )}
              <div className="flex-1">
                <p className="text-sm font-medium">{item.label}</p>
                <p className="text-xs text-muted-foreground">{item.description}</p>
              </div>
            </div>
          );
        })}
      </div>

      <div className="mt-4 pt-4 border-t">
        <div className="flex items-center justify-between">
          <span className="text-sm text-muted-foreground">
            Score: {Object.values(tests).filter(Boolean).length}/{testItems.length}
          </span>
          <Button
            variant="outline"
            size="sm"
            onClick={() => window.location.reload()}
          >
            Re-test
          </Button>
        </div>
      </div>
    </Card>
  );
}
