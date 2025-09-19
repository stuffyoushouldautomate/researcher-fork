// Copyright (c) 2025 Bytedance Ltd. and/or its affiliates
// SPDX-License-Identifier: MIT

import Link from "next/link";
import Image from "next/image";
import { env } from "~/env";

export function Logo() {
  return (
    <Link
      className="opacity-70 transition-opacity duration-300 hover:opacity-100"
      href="/"
    >
      {env.NEXT_PUBLIC_LOGO_URL ? (
        <Image
          src={env.NEXT_PUBLIC_LOGO_URL}
          alt={env.NEXT_PUBLIC_BRAND_NAME ?? "Logo"}
          width={120}
          height={32}
          priority
        />
      ) : (
        <>
          {env.NEXT_PUBLIC_BRAND_NAME ?? "🚜 Bulldozer"}
        </>
      )}
    </Link>
  );
}
