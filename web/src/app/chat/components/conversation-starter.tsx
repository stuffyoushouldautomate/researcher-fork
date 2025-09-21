// Copyright (c) 2025 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

import { motion } from "framer-motion";
import { useTranslations } from "next-intl";

import { useIsMobile } from "~/hooks/use-mobile";
import { cn } from "~/lib/utils";

import { Welcome } from "./welcome";

export function ConversationStarter({
  className,
  onSend,
}: {
  className?: string;
  onSend?: (message: string) => void;
}) {
  const t = useTranslations("chat");
  const isMobile = useIsMobile();
  const questions = t.raw("conversationStarters") as string[];

  return (
    <div className={cn("flex flex-col items-center", className)}>
      <div className="pointer-events-none fixed inset-0 flex items-center justify-center">
        <Welcome className={cn(
          "pointer-events-auto mb-15 -translate-y-24",
          isMobile ? "w-[90%]" : "w-[75%]"
        )} />
      </div>
      <ul className={cn(
        "flex",
        isMobile ? "flex-col gap-2 w-full px-4" : "flex-wrap"
      )}>
        {questions.map((question, index) => (
          <motion.li
            key={question}
            className={cn(
              "flex shrink-0",
              isMobile ? "w-full p-1" : "w-1/2 p-2"
            )}
            style={{ transition: "all 0.2s ease-out" }}
            initial={{ opacity: 0, y: 24 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -20 }}
            transition={{
              duration: 0.2,
              delay: index * 0.1 + 0.5,
              ease: "easeOut",
            }}
          >
            <div
              className={cn(
                "bg-card text-muted-foreground h-full w-full cursor-pointer border px-4 py-4 opacity-75 transition-all duration-300 hover:opacity-100 hover:shadow-md active:scale-105",
                isMobile ? "rounded-xl text-sm" : "rounded-2xl"
              )}
              onClick={() => {
                onSend?.(question);
              }}
            >
              {question}
            </div>
          </motion.li>
        ))}
      </ul>
    </div>
  );
}
