


export default function BloodStockRow({ type, progress, units, color }) {
  const isLow = progress < 0.3;
  const isMedium = progress >= 0.3 && progress < 0.6;
  
  return (
    <div className="group relative backdrop-blur-lg bg-white/40 dark:bg-gray-800/40 border border-white/30 dark:border-gray-700/30 rounded-2xl p-4 transition-all duration-300 hover:shadow-lg hover:scale-[1.02]">
      <div className="flex items-center justify-between mb-3">
        <div className="flex items-center gap-3">
          <div className={`w-12 h-12 rounded-xl bg-gradient-to-br from-${color} to-red-600 flex items-center justify-center shadow-lg`}>
            <span className="text-white font-bold text-lg">{type}</span>
          </div>
          <div>
            <p className="text-sm font-medium text-gray-600 dark:text-gray-400">Blood Type</p>
            <p className="text-2xl font-bold text-gray-900 dark:text-white">{units} units</p>
          </div>
        </div>
        <div className={`px-3 py-1 rounded-full text-xs font-semibold ${
          isLow ? 'bg-red-100 text-red-700 dark:bg-red-900/30 dark:text-red-400' :
          isMedium ? 'bg-amber-100 text-amber-700 dark:bg-amber-900/30 dark:text-amber-400' :
          'bg-emerald-100 text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-400'
        }`}>
          {(progress * 100).toFixed(0)}%
        </div>
      </div>
      
      <div className="relative h-2 bg-gray-200/50 dark:bg-gray-700/50 rounded-full overflow-hidden backdrop-blur-sm">
        <div 
          className={`absolute top-0 left-0 h-full bg-gradient-to-r from-${color} to-red-600 rounded-full transition-all duration-700 shadow-lg`}
          style={{ width: `${progress * 100}%` }}
        >
          <div className="absolute inset-0 bg-white/20 animate-pulse" />
        </div>
      </div>
    </div>
  );
}
