// Copyright (c) 2025 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

"use client";

import { BookOutlined } from "@ant-design/icons";
import dynamic from "next/dynamic";
import Link from "next/link";
import { useTranslations } from "next-intl";
import { Suspense } from "react";

import { MobileNavigation } from "~/components/mobile/mobile-navigation";
import { MobileResearch } from "~/components/mobile/mobile-research";
import { Button } from "~/components/ui/button";
import { useIsMobile } from "~/hooks/use-mobile";

import { Logo } from "../../components/deer-flow/logo";
import { ThemeToggle } from "../../components/deer-flow/theme-toggle";
import { Tooltip } from "../../components/deer-flow/tooltip";
import { SettingsDialog } from "../settings/dialogs/settings-dialog";

const Main = dynamic(() => import("./main"), {
  ssr: false,
  loading: () => (
    <div className="flex h-full w-full items-center justify-center">
      Loading Bulldozer...
    </div>
  ),
});

// const ResearchBlock = dynamic(() => import("./components/research-block").then(mod => ({ default: mod.ResearchBlock })), {
//   ssr: false,
// });

export default function HomePage() {
  const t = useTranslations("chat.page");
  const isMobile = useIsMobile();

  return (
    <div className="flex h-screen w-screen justify-center overscroll-none">
      <header className="fixed top-0 left-0 flex h-12 w-full items-center justify-between px-4 z-50 bg-background/80 backdrop-blur-md border-b border-border/50">
        <Logo />
        <div className="flex items-center gap-1">
          {/* Mobile: Only show essential buttons */}
          <div className="hidden sm:flex items-center gap-1">
            <Tooltip title={t("starOnGitHub")}>
              <Button variant="ghost" size="icon" asChild>
                <Link
                  href="https://resources.bulldozer825.com"
                  target="_blank"
                >
                  <BookOutlined />
                </Link>
              </Button>
            </Tooltip>
          </div>
          <ThemeToggle />
          <Suspense>
            <SettingsDialog />
          </Suspense>
        </div>
      </header>
      
      {isMobile ? (
        <MobileNavigation
          researchContent={<MobileResearch researchId="mobile-research" onClose={() => { /* Mobile research close handler */ }} />}
        >
          <Main />
        </MobileNavigation>
      ) : (
        <Main />
      )}
    </div>
  );
}
