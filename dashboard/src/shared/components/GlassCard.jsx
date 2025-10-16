import React from "react";

export default function GlassCard({ children, className = "" }) {
  return (
    <div
      className={`group relative backdrop-blur-xl bg-gradient-to-br from-white/10 via-white/5 to-transparent
      dark:from-white/5 dark:via-white/[0.02] dark:to-transparent
      border border-white/20 dark:border-white/10
      rounded-3xl shadow-2xl shadow-black/10 dark:shadow-black/50
      p-6 transition-all duration-500 ease-out
      hover:shadow-3xl hover:scale-[1.01]
      before:absolute before:inset-0 before:rounded-3xl before:bg-gradient-to-br 
      before:from-purple-500/5 before:via-transparent before:to-blue-500/5
      before:opacity-0 before:transition-opacity before:duration-500 hover:before:opacity-100
      overflow-hidden ${className}`}
    >
      <div className="absolute top-0 left-0 right-0 h-px bg-gradient-to-r from-transparent via-white/40 to-transparent opacity-50" />
      <div className="relative z-10">{children}</div>
    </div>
  );
}
