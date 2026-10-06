import 'package:flutter/material.dart';
import 'package:my_wallet/core/theme/app_color.dart';

/// كارت اختيار التاريخ الأسبوعي في الصفحة الرئيسية.
/// يعرض أسبوعاً واحداً مع إمكانية التنقل بين الأسابيع واختيار أي يوم.
class MonthlyCalendarCard extends StatefulWidget {
  final List<DateTime> transactionDates;

  const MonthlyCalendarCard({super.key, this.transactionDates = const []});

  @override
  State<MonthlyCalendarCard> createState() => _MonthlyCalendarCardState();
}

class _MonthlyCalendarCardState extends State<MonthlyCalendarCard> {
  static const _arabicMonths = [
    'يناير',
    'فبراير',
    'مارس',
    'إبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];
  static const _weekDays = ['أحد', 'إثن', 'ثلا', 'أرب', 'خمي', 'جمع', 'سبت'];

  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = _dateOnly(DateTime.now());
  }

  DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  DateTime get _weekStart =>
      _selectedDate.subtract(Duration(days: _selectedDate.weekday % 7));

  void _moveWeek(int weeks) {
    setState(
      () => _selectedDate = _selectedDate.add(Duration(days: 7 * weeks)),
    );
  }

  bool _hasTransaction(DateTime date) => widget.transactionDates.any(
    (transactionDate) => _dateOnly(transactionDate) == date,
  );

  @override
  Widget build(BuildContext context) {
    final weekDays = List.generate(
      7,
      (index) => _weekStart.add(Duration(days: index)),
    );
    final monthLabel =
        '${_arabicMonths[_selectedDate.month - 1]} ${_selectedDate.year}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderColor),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondaryColor.withOpacity(.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _CalendarHeader(
            title: monthLabel,
            onPrevious: () => _moveWeek(-1),
            onNext: () => _moveWeek(1),
          ),
          const SizedBox(height: 18),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              children: weekDays.map((date) {
                return Expanded(
                  child: _DateTile(
                    dayName: _weekDays[date.weekday % 7],
                    dayNumber: date.day,
                    isSelected: date == _selectedDate,
                    hasTransaction: _hasTransaction(date),
                    onTap: () => setState(() => _selectedDate = date),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  final String title;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const _CalendarHeader({
    required this.title,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        children: [
          const Icon(
            Icons.calendar_month_rounded,
            color: AppColors.primaryColor,
            size: 27,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          _NavigationButton(
            icon: Icons.chevron_right_rounded,
            tooltip: 'الأسبوع السابق',
            onTap: onPrevious,
          ),
          const SizedBox(width: 8),
          _NavigationButton(
            icon: Icons.chevron_left_rounded,
            tooltip: 'الأسبوع التالي',
            isPrimary: true,
            onTap: onNext,
          ),
        ],
      ),
    );
  }
}

class _DateTile extends StatelessWidget {
  final String dayName;
  final int dayNumber;
  final bool isSelected;
  final bool hasTransaction;
  final VoidCallback onTap;

  const _DateTile({
    required this.dayName,
    required this.dayNumber,
    required this.isSelected,
    required this.hasTransaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final foregroundColor = isSelected ? Colors.white : AppColors.textPrimary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            height: 104,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryColor : AppColors.background,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryColor
                    : AppColors.primaryColor.withOpacity(.16),
                width: 1.5,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(.28),
                        blurRadius: 14,
                        offset: const Offset(0, 7),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dayName,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white.withOpacity(.9)
                        : AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$dayNumber',
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  height: 4,
                  child: hasTransaction
                      ? Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : AppColors.accentColor,
                            shape: BoxShape.circle,
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavigationButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final bool isPrimary;
  final VoidCallback onTap;

  const _NavigationButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: isPrimary
            ? AppColors.primaryColor.withOpacity(.08)
            : AppColors.neutralColor,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: isPrimary
                  ? Border.all(color: AppColors.primaryColor.withOpacity(.35))
                  : null,
            ),
            child: Icon(
              icon,
              color: isPrimary
                  ? AppColors.primaryColor
                  : AppColors.textSecondary,
              size: 26,
            ),
          ),
        ),
      ),
    );
  }
}
