// Copyright (c) 2025 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

export const playbook = {
  steps: [
    {
      description:
        "Union organizers submit research requests to investigate companies, track violations, or analyze labor practices.",
      activeNodes: ["Start", "Coordinator"],
      activeEdges: ["Start->Coordinator"],
      tooltipPosition: "right",
    },
    {
      description:
        "The Union Coordinator analyzes the request and creates an investigation plan tailored to labor union needs.",
      activeNodes: ["Coordinator", "Planner"],
      activeEdges: ["Coordinator->Planner"],
      tooltipPosition: "left",
    },
    {
      description: "Union organizers review and refine the investigation plan to ensure it meets their specific needs.",
      activeNodes: ["Planner", "HumanFeedback"],
      activeEdges: ["Planner->HumanFeedback"],
      tooltipPosition: "left",
    },
    {
      description: "The plan is updated based on union organizer feedback and strategic priorities.",
      activeNodes: ["HumanFeedback", "Planner"],
      activeEdges: ["HumanFeedback->Planner"],
      tooltipPosition: "left",
    },
    {
      description:
        "The Research Team begins comprehensive investigation of company practices, violations, and labor conditions.",
      activeNodes: ["Planner", "HumanFeedback", "ResearchTeam"],
      activeEdges: [
        "Planner->HumanFeedback",
        "HumanFeedback->ResearchTeam",
        "ResearchTeam->HumanFeedback",
      ],
      tooltipPosition: "left",
    },
    {
      description:
        "Company Investigators search for labor violations, safety records, wage theft cases, and anti-union activities.",
      activeNodes: ["ResearchTeam", "Researcher"],
      activeEdges: ["ResearchTeam->Researcher", "Researcher->ResearchTeam"],
      tooltipPosition: "left",
    },
    {
      description:
        "Data Analysts process labor statistics, calculate wage gaps, analyze OSHA violations, and compile evidence for union campaigns.",
      tooltipPosition: "right",
      activeNodes: ["ResearchTeam", "Coder"],
      activeEdges: ["ResearchTeam->Coder", "Coder->ResearchTeam"],
    },
    {
      description:
        "Once investigation is complete, findings are compiled and prepared for union organizing campaigns.",
      activeNodes: ["ResearchTeam", "Planner"],
      activeEdges: ["ResearchTeam->Planner"],
      tooltipPosition: "left",
    },
    {
      description:
        "The Investigation Planner reviews findings and prepares comprehensive reports for union meetings and legal cases.",
      activeNodes: ["Reporter", "Planner"],
      activeEdges: ["Planner->Reporter"],
      tooltipPosition: "right",
    },
    {
      description:
        "Union reports are generated with actionable insights, violation documentation, and strategic recommendations for organizing campaigns.",
      activeNodes: ["End", "Reporter"],
      activeEdges: ["Reporter->End"],
      tooltipPosition: "bottom",
    },
  ],
};
