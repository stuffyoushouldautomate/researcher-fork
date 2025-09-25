// Copyright (c) 2025 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

import Link from "next/link";
import Image from "next/image";

export function Logo() {
  return (
    <Link
      className="opacity-70 transition-opacity duration-300 hover:opacity-100"
      href="/"
    >
      <Image
        src="/logo.png"
        alt="Bulldozer™"
        width={120}
        height={32}
        priority
        style={{ width: "auto", height: "auto" }}
      />
    </Link>
  );
}
