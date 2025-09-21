// Copyright (c) 2025 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

"use client";

import { motion } from "framer-motion";
import { ArrowLeft, Download, Share, Star } from "lucide-react";
import { useState } from "react";

import { Button } from "~/components/ui/button";
import { Card } from "~/components/ui/card";
import { cn } from "~/lib/utils";

interface MobileResearchProps {
  researchId: string;
  onClose: () => void;
}

export function MobileResearch({ researchId, onClose }: MobileResearchProps) {
  const [activeTab, setActiveTab] = useState<"overview" | "sources" | "analysis">("overview");
  
  // Mock research data - in real app this would come from props or API
  const researchData = {
    title: "Labor Union Research Report",
    company: "TechCorp Inc.",
    summary: "Comprehensive analysis of labor conditions, union activity, and worker rights at TechCorp Inc.",
    keyFindings: [
      "Recent unionization efforts in Seattle office",
      "Wage disparities between departments",
      "Safety concerns in manufacturing facilities",
      "Management response to union activities"
    ],
    sources: [
      { title: "NLRB Filing Documents", type: "Legal", date: "2024-01-15" },
      { title: "Employee Testimonies", type: "Interview", date: "2024-01-20" },
      { title: "Financial Reports", type: "Document", date: "2024-01-10" },
      { title: "News Articles", type: "Media", date: "2024-01-25" }
    ],
    analysis: {
      riskLevel: "High",
      recommendations: [
        "Support union organizing efforts",
        "Document wage disparities",
        "Report safety violations to OSHA",
        "Connect with existing union members"
      ]
    }
  };
  
  const tabs = [
    { id: "overview", label: "Overview", icon: "📊" },
    { id: "sources", label: "Sources", icon: "📚" },
    { id: "analysis", label: "Analysis", icon: "🔍" }
  ] as const;
  
  return (
    <div className="flex h-full flex-col bg-background">
      {/* Header */}
      <div className="flex h-14 items-center justify-between border-b border-border bg-background/95 backdrop-blur-md px-4 safe-area-top">
        <Button
          variant="ghost"
          size="icon"
          onClick={onClose}
          className="h-8 w-8"
        >
          <ArrowLeft className="h-4 w-4" />
        </Button>
        
        <div className="flex items-center gap-2">
          <h1 className="text-lg font-semibold">Research</h1>
        </div>
        
        <div className="flex items-center gap-1">
          <Button variant="ghost" size="icon" className="h-8 w-8">
            <Share className="h-4 w-4" />
          </Button>
          <Button variant="ghost" size="icon" className="h-8 w-8">
            <Download className="h-4 w-4" />
          </Button>
        </div>
      </div>
      
      {/* Tab Navigation */}
      <div className="flex border-b border-border bg-background">
        {tabs.map((tab) => (
          <button
            key={tab.id}
            className={cn(
              "flex flex-1 items-center justify-center gap-2 px-4 py-3 text-sm font-medium transition-colors",
              activeTab === tab.id
                ? "border-b-2 border-brand text-brand"
                : "text-muted-foreground hover:text-foreground"
            )}
            onClick={() => setActiveTab(tab.id)}
          >
            <span>{tab.icon}</span>
            <span className="hidden sm:inline">{tab.label}</span>
          </button>
        ))}
      </div>
      
      {/* Content */}
      <div className="flex-1 overflow-auto ios-scroll px-4 py-4">
        {activeTab === "overview" && (
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.3 }}
            className="space-y-4"
          >
            <Card className="p-4">
              <h2 className="text-lg font-semibold mb-2">{researchData.title}</h2>
              <p className="text-muted-foreground text-sm mb-4">{researchData.summary}</p>
              
              <div className="space-y-3">
                <h3 className="font-medium">Key Findings</h3>
                {researchData.keyFindings.map((finding, index) => (
                  <div key={index} className="flex items-start gap-3">
                    <div className="mt-1 h-2 w-2 rounded-full bg-brand flex-shrink-0" />
                    <p className="text-sm">{finding}</p>
                  </div>
                ))}
              </div>
            </Card>
          </motion.div>
        )}
        
        {activeTab === "sources" && (
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.3 }}
            className="space-y-3"
          >
            {researchData.sources.map((source, index) => (
              <Card key={index} className="p-4">
                <div className="flex items-start justify-between">
                  <div className="flex-1">
                    <h3 className="font-medium text-sm">{source.title}</h3>
                    <div className="flex items-center gap-2 mt-1">
                      <span className="text-xs text-muted-foreground bg-muted px-2 py-1 rounded">
                        {source.type}
                      </span>
                      <span className="text-xs text-muted-foreground">{source.date}</span>
                    </div>
                  </div>
                  <Button variant="ghost" size="icon" className="h-8 w-8">
                    <Star className="h-4 w-4" />
                  </Button>
                </div>
              </Card>
            ))}
          </motion.div>
        )}
        
        {activeTab === "analysis" && (
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.3 }}
            className="space-y-4"
          >
            <Card className="p-4">
              <div className="flex items-center justify-between mb-4">
                <h3 className="font-medium">Risk Assessment</h3>
                <span className={cn(
                  "px-3 py-1 rounded-full text-xs font-medium",
                  researchData.analysis.riskLevel === "High" 
                    ? "bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-200"
                    : "bg-yellow-100 text-yellow-800 dark:bg-yellow-900 dark:text-yellow-200"
                )}>
                  {researchData.analysis.riskLevel} Risk
                </span>
              </div>
              
              <div className="space-y-3">
                <h4 className="font-medium">Recommendations</h4>
                {researchData.analysis.recommendations.map((rec, index) => (
                  <div key={index} className="flex items-start gap-3">
                    <div className="mt-1 h-2 w-2 rounded-full bg-green-500 flex-shrink-0" />
                    <p className="text-sm">{rec}</p>
                  </div>
                ))}
              </div>
            </Card>
          </motion.div>
        )}
      </div>
      
      {/* Bottom Actions */}
      <div className="border-t border-border bg-background/95 backdrop-blur-md p-4 safe-area-bottom">
        <div className="flex gap-3">
          <Button className="flex-1" size="lg">
            Export Report
          </Button>
          <Button variant="outline" size="lg">
            Share
          </Button>
        </div>
      </div>
    </div>
  );
}
