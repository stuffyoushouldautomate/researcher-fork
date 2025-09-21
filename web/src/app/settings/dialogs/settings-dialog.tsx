// Copyright (c) 2025 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

import { motion, AnimatePresence } from "framer-motion";
import { ArrowLeft, Settings } from "lucide-react";
import { useTranslations } from 'next-intl';
import { useCallback, useEffect, useMemo, useState } from "react";

import { Tooltip } from "~/components/deer-flow/tooltip";
import { Badge } from "~/components/ui/badge";
import { Button } from "~/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "~/components/ui/dialog";
import { Tabs, TabsContent } from "~/components/ui/tabs";
import { useReplay } from "~/core/replay";
import {
  type SettingsState,
  changeSettings,
  saveSettings,
  useSettingsStore,
} from "~/core/store";
import { useIsMobile } from "~/hooks/use-mobile";
import { cn } from "~/lib/utils";

import { SETTINGS_TABS } from "../tabs";

export function SettingsDialog() {
  const t = useTranslations('settings');
  const tCommon = useTranslations('common');
  const { isReplay } = useReplay();
  const isMobile = useIsMobile();
  const [activeTabId, setActiveTabId] = useState(SETTINGS_TABS[0]!.id);
  const [open, setOpen] = useState(false);
  const [settings, setSettings] = useState(useSettingsStore.getState());
  const [changes, setChanges] = useState<Partial<SettingsState>>({});

  const handleTabChange = useCallback(
    (newChanges: Partial<SettingsState>) => {
      setTimeout(() => {
        if (open) {
          setChanges((prev) => ({
            ...prev,
            ...newChanges,
          }));
        }
      }, 0);
    },
    [open],
  );

  const handleSave = useCallback(() => {
    if (Object.keys(changes).length > 0) {
      const newSettings: SettingsState = {
        ...settings,
        ...changes,
      };
      setSettings(newSettings);
      setChanges({});
      changeSettings(newSettings);
      saveSettings();
    }
    setOpen(false);
  }, [settings, changes]);

  const handleOpen = useCallback(() => {
    setSettings(useSettingsStore.getState());
  }, []);

  const handleClose = useCallback(() => {
    setChanges({});
  }, []);

  useEffect(() => {
    if (open) {
      handleOpen();
    } else {
      handleClose();
    }
  }, [open, handleOpen, handleClose]);

  const mergedSettings = useMemo<SettingsState>(() => {
    return {
      ...settings,
      ...changes,
    };
  }, [settings, changes]);

  if (isReplay) {
    return null;
  }

  // Mobile full-screen modal
  if (isMobile) {
    return (
      <>
        <Tooltip title={tCommon('settings')}>
          <Button variant="ghost" size="icon" onClick={() => setOpen(true)}>
            <Settings />
          </Button>
        </Tooltip>
        
        <AnimatePresence>
          {open && (
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              className="fixed inset-0 z-50 bg-background"
            >
              {/* Header */}
              <div className="flex h-14 items-center justify-between border-b border-border bg-background/95 backdrop-blur-md px-4 safe-area-top">
                <Button
                  variant="ghost"
                  size="icon"
                  onClick={() => setOpen(false)}
                  className="h-8 w-8"
                >
                  <ArrowLeft className="h-4 w-4" />
                </Button>
                
                <div className="flex items-center gap-2">
                  <h1 className="text-lg font-semibold">{t('title')}</h1>
                </div>
                
                <div className="w-8" /> {/* Spacer for alignment */}
              </div>

              {/* Tab Navigation */}
              <div className="flex border-b border-border bg-background">
                {SETTINGS_TABS.map((tab) => (
                  <button
                    key={tab.id}
                    className={cn(
                      "flex flex-1 items-center justify-center gap-2 px-4 py-3 text-sm font-medium transition-colors",
                      activeTabId === tab.id
                        ? "border-b-2 border-brand text-brand"
                        : "text-muted-foreground hover:text-foreground"
                    )}
                    onClick={() => setActiveTabId(tab.id)}
                  >
                    <tab.icon size={16} />
                    <span className="hidden sm:inline">{tab.label}</span>
                    {tab.badge && (
                      <Badge
                        variant="outline"
                        className="ml-1 px-1 py-0 text-xs"
                      >
                        {tab.badge}
                      </Badge>
                    )}
                  </button>
                ))}
              </div>

              {/* Content */}
              <div className="flex-1 overflow-auto ios-scroll px-4 py-4">
                <motion.div
                  key={activeTabId}
                  initial={{ opacity: 0, y: 20 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ duration: 0.3 }}
                  className="space-y-4"
                >
                  {SETTINGS_TABS.map((tab) => (
                    <div key={tab.id} className={activeTabId === tab.id ? "block" : "hidden"}>
                      <tab.component
                        settings={mergedSettings}
                        onChange={handleTabChange}
                      />
                    </div>
                  ))}
                </motion.div>
              </div>

              {/* Bottom Actions */}
              <div className="border-t border-border bg-background/95 backdrop-blur-md p-4 safe-area-bottom">
                <div className="flex gap-3">
                  <Button 
                    variant="outline" 
                    className="flex-1" 
                    size="lg"
                    onClick={() => setOpen(false)}
                  >
                    {tCommon('cancel')}
                  </Button>
                  <Button 
                    className="flex-1" 
                    size="lg"
                    onClick={handleSave}
                  >
                    {tCommon('save')}
                  </Button>
                </div>
              </div>
            </motion.div>
          )}
        </AnimatePresence>
      </>
    );
  }

  // Desktop dialog
  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <Tooltip title={tCommon('settings')}>
        <DialogTrigger asChild>
          <Button variant="ghost" size="icon">
            <Settings />
          </Button>
        </DialogTrigger>
      </Tooltip>
      <DialogContent className="sm:max-w-[850px]">
        <DialogHeader>
          <DialogTitle>{t('title')}</DialogTitle>
          <DialogDescription>
            {t('description')}
          </DialogDescription>
        </DialogHeader>
        <Tabs value={activeTabId}>
          <div className="flex h-120 w-full overflow-auto border-y">
            <ul className="flex w-50 shrink-0 border-r p-1">
              <div className="size-full">
                {SETTINGS_TABS.map((tab) => (
                  <li
                    key={tab.id}
                    className={cn(
                      "hover:accent-foreground hover:bg-accent mb-1 flex h-8 w-full cursor-pointer items-center gap-1.5 rounded px-2",
                      activeTabId === tab.id &&
                        "!bg-primary !text-primary-foreground",
                    )}
                    onClick={() => setActiveTabId(tab.id)}
                  >
                    <tab.icon size={16} />
                    <span>{tab.label}</span>
                    {tab.badge && (
                      <Badge
                        variant="outline"
                        className={cn(
                          "border-muted-foreground text-muted-foreground ml-auto px-1 py-0 text-xs",
                          activeTabId === tab.id &&
                            "border-primary-foreground text-primary-foreground",
                        )}
                      >
                        {tab.badge}
                      </Badge>
                    )}
                  </li>
                ))}
              </div>
            </ul>
            <div className="min-w-0 flex-grow">
              <div
                id="settings-content-scrollable"
                className="size-full overflow-auto p-4"
              >
                {SETTINGS_TABS.map((tab) => (
                  <TabsContent key={tab.id} value={tab.id}>
                    <tab.component
                      settings={mergedSettings}
                      onChange={handleTabChange}
                    />
                  </TabsContent>
                ))}
              </div>
            </div>
          </div>
        </Tabs>
        <DialogFooter>
          <Button variant="outline" onClick={() => setOpen(false)}>
            {tCommon('cancel')}
          </Button>
          <Button className="w-24" type="submit" onClick={handleSave}>
            {tCommon('save')}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
