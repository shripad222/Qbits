export default function StatItem({ icon: Icon, label, value, trend }) {
  return (
    <div className="group relative backdrop-blur-md bg-white/30 dark:bg-gray-800/30 border border-white/40 dark:border-gray-700/40 rounded-2xl p-4 transition-all duration-300 hover:shadow-md hover:scale-105">
      <div className="flex items-center gap-3 mb-2">
        <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-red-500 to-pink-600 flex items-center justify-center shadow-md">
          <Icon className="w-5 h-5 text-white" />
        </div>
        <p className="text-sm font-medium text-gray-600 dark:text-gray-400">{label}</p>
      </div>
      <p className="text-xl font-bold text-gray-900 dark:text-white ml-13">{value}</p>
      {trend && (
        <p className={`text-xs mt-1 ml-13 ${trend > 0 ? 'text-emerald-600 dark:text-emerald-400' : 'text-red-600 dark:text-red-400'}`}>
          {trend > 0 ? '↑' : '↓'} {Math.abs(trend)}% from last week
        </p>
      )}
    </div>
  );
}