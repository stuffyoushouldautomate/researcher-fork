// Copyright (c) 2025 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

import { Building, Users, Shield, Briefcase, Scale, Factory, FileText, TrendingUp } from "lucide-react";
import { useTranslations } from "next-intl";

import { BentoCard } from "~/components/magicui/bento-grid";

import { SectionHeader } from "../components/section-header";

const caseStudyIcons = [
  { id: "labor-violations-retail", icon: Building },
  { id: "union-membership-rates", icon: Users },
  { id: "osha-violations-construction", icon: Shield },
  { id: "gig-economy-workers", icon: Briefcase },
  { id: "minimum-wage-campaigns", icon: Scale },
  { id: "union-organizing-drives", icon: Factory },
  { id: "manufacturing-safety", icon: FileText },
  { id: "labor-laws-by-state", icon: TrendingUp },
];

export function CaseStudySection() {
  const t = useTranslations("landing.caseStudies");
  const cases = t.raw("cases") as Array<{ title: string; description: string }>;

  return (
    <section className="relative container hidden flex-col items-center justify-center md:flex">
      <SectionHeader
        anchor="case-studies"
        title={t("title")}
        description={t("description")}
      />
      <div className="grid w-3/4 grid-cols-1 gap-2 sm:w-full sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
        {cases.map((caseStudy, index) => {
          const iconData = caseStudyIcons[index];
          return (
            <div key={caseStudy.title} className="w-full p-2">
              <BentoCard
                {...{
                  Icon: iconData?.icon ?? Building,
                  name: caseStudy.title,
                  description: caseStudy.description,
                  href: `/chat?replay=${iconData?.id}`,
                  cta: t("clickToWatch"),
                  className: "w-full h-full",
                }}
              />
            </div>
          );
        })}
      </div>
    </section>
  );
}
