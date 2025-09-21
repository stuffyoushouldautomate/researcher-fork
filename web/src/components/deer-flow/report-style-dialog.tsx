// Copyright (c) 2025 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

import { useTranslations } from "next-intl";
import { useState } from "react";
import { Check, FileText, Newspaper, Users, GraduationCap, Search, Target } from "lucide-react";

import { Button } from "~/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "~/components/ui/dialog";
import { setReportStyle, useSettingsStore } from "~/core/store";
import { cn } from "~/lib/utils";

import { Tooltip } from "./tooltip";

const REPORT_STYLES = [
  {
    value: "bulldozer" as const,
    labelKey: "bulldozer",
    descriptionKey: "bulldozerDesc",
    icon: GraduationCap,
  },
  {
    value: "union_organizer" as const,
    labelKey: "unionOrganizer",
    descriptionKey: "unionOrganizerDesc",
    icon: Users,
  },
  {
    value: "investigator" as const,
    labelKey: "investigator",
    descriptionKey: "investigatorDesc",
    icon: Search,
  },
  {
    value: "resource_expert" as const,
    labelKey: "resourceExpert",
    descriptionKey: "resourceExpertDesc",
    icon: FileText,
  },
  {
    value: "strategist" as const,
    labelKey: "strategist",
    descriptionKey: "strategistDesc",
    icon: Target,
  },
  {
    value: "reporter" as const,
    labelKey: "reporter",
    descriptionKey: "reporterDesc",
    icon: Newspaper,
  },
];

export function ReportStyleDialog() {
  const t = useTranslations("settings.reportStyle");
  const [open, setOpen] = useState(false);
  const currentStyle = useSettingsStore((state) => state.general.reportStyle);

  const handleStyleChange = (
    style: "bulldozer" | "union_organizer" | "investigator" | "resource_expert" | "strategist" | "reporter",
  ) => {
    setReportStyle(style);
    setOpen(false);
  };

  const currentStyleConfig =
    REPORT_STYLES.find((style) => style.value === currentStyle) ||
    REPORT_STYLES[0]!;
  const CurrentIcon = currentStyleConfig.icon;

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <Tooltip
        className="max-w-60"
        title={
          <div>
            <h3 className="mb-2 font-bold">
              {t("writingStyle")}: {t(currentStyleConfig.labelKey)}
            </h3>
            <p>{t("chooseDesc")}</p>
          </div>
        }
      >
        <DialogTrigger asChild>
          <Button
            className="!border-brand !text-brand rounded-2xl"
            variant="outline"
          >
            <CurrentIcon className="h-4 w-4" /> {t(currentStyleConfig.labelKey)}
          </Button>
        </DialogTrigger>
      </Tooltip>
      <DialogContent className="sm:max-w-[500px]">
        <DialogHeader>
          <DialogTitle>{t("chooseTitle")}</DialogTitle>
          <DialogDescription>{t("chooseDesc")}</DialogDescription>
        </DialogHeader>
        <div className="grid gap-3 py-4">
          {REPORT_STYLES.map((style) => {
            const Icon = style.icon;
            const isSelected = currentStyle === style.value;

            return (
              <button
                key={style.value}
                className={cn(
                  "hover:bg-accent flex items-start gap-3 rounded-lg border p-4 text-left transition-colors",
                  isSelected && "border-primary bg-accent",
                )}
                onClick={() => handleStyleChange(style.value)}
              >
                <Icon className="mt-0.5 h-5 w-5 shrink-0" />
                <div className="flex-1 space-y-1">
                  <div className="flex items-center gap-2">
                    <h4 className="font-medium">{t(style.labelKey)}</h4>
                    {isSelected && <Check className="text-primary h-4 w-4" />}
                  </div>
                  <p className="text-muted-foreground text-sm">
                    {t(style.descriptionKey)}
                  </p>
                </div>
              </button>
            );
          })}
        </div>
      </DialogContent>
    </Dialog>
  );
}
