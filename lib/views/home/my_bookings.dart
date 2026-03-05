import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// Data Model
// ─────────────────────────────────────────────
class SlotModel {
  final String id;
  final String duration;
  final String timeRange;
  final double price;
  bool isActive;
  bool isBooked;

  SlotModel({
    required this.id,
    required this.duration,
    required this.timeRange,
    required this.price,
    this.isActive = true,
    this.isBooked = false,
  });
}

class BookingModel {
  final String id;
  final String farmhouseName;
  final String location;
  final double pricePerNight;
  final String imageUrl;
  final String checkIn;
  final String checkOut;
  final String status;
  final double rating;
  final int reviews;
  final List<String> amenities;
  List<SlotModel> slots;

  BookingModel({
    required this.id,
    required this.farmhouseName,
    required this.location,
    required this.pricePerNight,
    required this.imageUrl,
    required this.checkIn,
    required this.checkOut,
    required this.status,
    required this.rating,
    required this.reviews,
    required this.amenities,
    required this.slots,
  });
}

// ─────────────────────────────────────────────
// Main Page
// ─────────────────────────────────────────────
class MyBookings extends StatefulWidget {
  const MyBookings({super.key});

  @override
  State<MyBookings> createState() => _MyBookingsState();
}

class _MyBookingsState extends State<MyBookings>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTab = 0;

  final List<BookingModel> _bookings = [
    BookingModel(
      id: 'BK-2024-001',
      farmhouseName: 'Green Meadows Farmhouse',
      location: 'Lonavala, Maharashtra',
      pricePerNight: 4500,
      imageUrl:
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=600',
      checkIn: '15 Mar 2025',
      checkOut: '17 Mar 2025',
      status: 'Upcoming',
      rating: 4.8,
      reviews: 124,
      amenities: ['Pool', 'BBQ', 'WiFi', 'Parking'],
      slots: [
        SlotModel(
          id: 's1',
          duration: '22hrs',
          timeRange: '12:00 PM – 10:00 AM',
          price: 4500,
          isBooked: true,
          isActive: true,
        ),
        SlotModel(
          id: 's2',
          duration: '12hrs',
          timeRange: '10:00 AM – 10:00 PM',
          price: 2800,
          isBooked: false,
          isActive: true,
        ),
        SlotModel(
          id: 's3',
          duration: '6hrs',
          timeRange: '06:00 AM – 12:00 PM',
          price: 1500,
          isBooked: false,
          isActive: false,
        ),
      ],
    ),
    BookingModel(
      id: 'BK-2024-002',
      farmhouseName: 'Sunset Valley Retreat',
      location: 'Alibaug, Maharashtra',
      pricePerNight: 6200,
      imageUrl:
          'https://images.unsplash.com/photo-1568605114967-8130f3a36994?w=600',
      checkIn: '02 Feb 2025',
      checkOut: '04 Feb 2025',
      status: 'Completed',
      rating: 4.6,
      reviews: 89,
      amenities: ['Beach Access', 'AC', 'Kitchen', 'Garden'],
      slots: [
        SlotModel(
          id: 's4',
          duration: '24hrs',
          timeRange: '12:00 PM – 12:00 PM',
          price: 6200,
          isBooked: true,
          isActive: true,
        ),
      ],
    ),
    BookingModel(
      id: 'BK-2024-003',
      farmhouseName: 'Hilltop Heritage Bungalow',
      location: 'Mahabaleshwar, Maharashtra',
      pricePerNight: 3800,
      imageUrl:
          'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=600',
      checkIn: '20 Jan 2025',
      checkOut: '21 Jan 2025',
      status: 'Cancelled',
      rating: 4.3,
      reviews: 56,
      amenities: ['Fireplace', 'Trekking', 'WiFi'],
      slots: [
        SlotModel(
          id: 's5',
          duration: '22hrs',
          timeRange: '12:00 PM – 10:00 AM',
          price: 3800,
          isBooked: false,
          isActive: false,
        ),
      ],
    ),
  ];

  List<BookingModel> get _filteredBookings {
    if (_selectedTab == 0) return _bookings;
    final statuses = ['Upcoming', 'Completed', 'Cancelled'];
    return _bookings
        .where((b) => b.status == statuses[_selectedTab - 1])
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() => _selectedTab = _tabController.index);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: _filteredBookings.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: _filteredBookings.length,
                    itemBuilder: (context, index) {
                      return _BookingCard(
                        booking: _filteredBookings[index],
                        onManageSlots: () =>
                            _showManageSlotsSheet(_filteredBookings[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: const Color(0xFF1B4332),
      centerTitle: true,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            'My Bookings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
          // Text(
          //   'Manage your reservations',
          //   style: TextStyle(
          //     color: Color(0xFF95D5B2),
          //     fontSize: 12,
          //     fontWeight: FontWeight.w400,
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    final tabs = ['All', 'Upcoming', 'Completed', 'Cancelled'];
    return Container(
      color: const Color(0xFF1B4332),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        indicatorColor: const Color(0xFF52B788),
        indicatorWeight: 3,
        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xFF95D5B2),
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        tabs: tabs.map((t) => Tab(text: t)).toList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No bookings found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your reservations will appear here',
            style: TextStyle(fontSize: 14, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  void _showManageSlotsSheet(BookingModel booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ManageSlotsSheet(
        booking: booking,
        onSlotUpdated: () => setState(() {}),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Booking Card
// ─────────────────────────────────────────────
class _BookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback onManageSlots;

  const _BookingCard({required this.booking, required this.onManageSlots});

  Color get _statusColor {
    switch (booking.status) {
      case 'Upcoming':
        return const Color(0xFF2D6A4F);
      case 'Completed':
        return const Color(0xFF1565C0);
      case 'Cancelled':
        return const Color(0xFFC62828);
      default:
        return Colors.grey;
    }
  }

  IconData get _statusIcon {
    switch (booking.status) {
      case 'Upcoming':
        return Icons.schedule;
      case 'Completed':
        return Icons.check_circle_outline;
      case 'Cancelled':
        return Icons.cancel_outlined;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Image.network(
                  booking.imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (_, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      height: 180,
                      color: const Color(0xFFE8F5E9),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF2D6A4F),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => Container(
                    height: 180,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF2D6A4F), Color(0xFF52B788)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.home_work_outlined,
                        size: 64,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                ),
              ),
              // Status Badge
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: _statusColor.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_statusIcon, color: Colors.white, size: 13),
                      const SizedBox(width: 4),
                      Text(
                        booking.status,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Price Badge
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.65),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '₹${booking.pricePerNight.toStringAsFixed(0)}/night',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              // Booking ID ribbon
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: Text(
                    'Booking ID: ${booking.id}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Details Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name & Rating
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        booking.farmhouseName,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1B2D1F),
                          height: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FBF4),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFF95D5B2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Color(0xFFF4A024),
                            size: 16,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            booking.rating.toString(),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1B4332),
                            ),
                          ),
                          Text(
                            ' (${booking.reviews})',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF74A98E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Location
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: Color(0xFF52B788),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      booking.location,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF5A7A65),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Date Row
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FBF4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFB7E4C7),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      _DateChip(label: 'Check-in', value: booking.checkIn),
                      const Expanded(
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(width: 4),
                              Icon(
                                Icons.arrow_forward,
                                size: 16,
                                color: Color(0xFF52B788),
                              ),
                              SizedBox(width: 4),
                            ],
                          ),
                        ),
                      ),
                      _DateChip(label: 'Check-out', value: booking.checkOut),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Amenities
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: booking.amenities
                      .map((a) => _AmenityChip(label: a))
                      .toList(),
                ),
                const SizedBox(height: 16),

                // Manage Slots Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onManageSlots,
                    icon: const Icon(
                      Icons.calendar_view_week_rounded,
                      size: 18,
                    ),
                    label: const Text('Manage Slots'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2D6A4F),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  final String label;
  final String value;
  const _DateChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF74A98E),
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1B4332),
          ),
        ),
      ],
    );
  }
}

class _AmenityChip extends StatelessWidget {
  final String label;
  const _AmenityChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFB7E4C7), width: 1),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2D6A4F),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Manage Slots Bottom Sheet
// ─────────────────────────────────────────────
class _ManageSlotsSheet extends StatefulWidget {
  final BookingModel booking;
  final VoidCallback onSlotUpdated;

  const _ManageSlotsSheet({required this.booking, required this.onSlotUpdated});

  @override
  State<_ManageSlotsSheet> createState() => _ManageSlotsSheetState();
}

class _ManageSlotsSheetState extends State<_ManageSlotsSheet> {
  DateTime? _selectedDate;

  List<SlotModel> get _filteredSlots => _selectedDate == null
      ? widget.booking.slots
      : widget.booking.slots; // filter logic can be wired to real dates

  void _showDeactivateDialog(SlotModel slot) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => _DeactivateDialog(
        slot: slot,
        onConfirm: (reason) {
          setState(() {
            slot.isActive = false;
          });
          widget.onSlotUpdated();
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Slot deactivated successfully'),
              backgroundColor: const Color.fromARGB(255, 255, 60, 0),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showActivateDialog(SlotModel slot) {
    setState(() => slot.isActive = true);
    widget.onSlotUpdated();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Slot activated successfully'),
        backgroundColor: const Color(0xFF1565C0),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle Bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.calendar_view_week_rounded,
                    color: Color(0xFF2D6A4F),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Available Slots',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1B2D1F),
                        ),
                      ),
                      Text(
                        widget.booking.farmhouseName,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF74A98E),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Color(0xFF5A7A65),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 24, indent: 20, endIndent: 20),

          // Date Picker
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  builder: (ctx, child) => Theme(
                    data: ThemeData(
                      colorScheme: const ColorScheme.light(
                        primary: Color(0xFF2D6A4F),
                        onPrimary: Colors.white,
                      ),
                    ),
                    child: child!,
                  ),
                );
                if (picked != null) setState(() => _selectedDate = picked);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFB7E4C7),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFFF9FEFB),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      color: Color(0xFF2D6A4F),
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _selectedDate == null
                          ? 'Select a date to filter'
                          : '${_selectedDate!.day.toString().padLeft(2, '0')}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.year}',
                      style: TextStyle(
                        color: _selectedDate == null
                            ? const Color(0xFF9DB5A4)
                            : const Color(0xFF1B4332),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    if (_selectedDate != null)
                      GestureDetector(
                        onTap: () => setState(() => _selectedDate = null),
                        child: const Icon(
                          Icons.clear_rounded,
                          color: Color(0xFF74A98E),
                          size: 18,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Slots List
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.45,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
              itemCount: _filteredSlots.length,
              itemBuilder: (ctx, i) {
                final slot = _filteredSlots[i];
                return _SlotTile(
                  slot: slot,
                  onToggle: (val) {
                    if (!val) {
                      _showDeactivateDialog(slot);
                    } else {
                      _showActivateDialog(slot);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Slot Tile
// ─────────────────────────────────────────────
class _SlotTile extends StatelessWidget {
  final SlotModel slot;
  final ValueChanged<bool> onToggle;

  const _SlotTile({required this.slot, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final isActive = slot.isActive;
    final isBooked = slot.isBooked;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isActive
              ? const Color(0xFFB7E4C7)
              : Colors.grey.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: const Color(0xFF2D6A4F).withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: Row(
        children: [
          // Time Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? const Color(0xFFE8F5E9)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        slot.duration,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: isActive
                              ? const Color(0xFF2D6A4F)
                              : Colors.grey[500],
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (isBooked)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3E0),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.lock_outline_rounded,
                              size: 10,
                              color: Color(0xFFE65100),
                            ),
                            SizedBox(width: 3),
                            Text(
                              'Booked',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFE65100),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 13,
                      color: Color(0xFF74A98E),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      slot.timeRange,
                      style: TextStyle(
                        fontSize: 13,
                        color: isActive
                            ? const Color(0xFF3D6B52)
                            : Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${slot.price.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: isActive
                        ? const Color(0xFF1B4332)
                        : Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),

          // Toggle
          Column(
            children: [
              Transform.scale(
                scale: 0.85,
                child: Switch(
                  value: isActive,
                  onChanged: isBooked ? null : onToggle,
                  activeColor: Colors.white,
                  activeTrackColor: const Color(0xFF2D6A4F),
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.grey[300],
                ),
              ),
              Text(
                isActive ? 'Active' : 'Off',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isActive ? const Color(0xFF2D6A4F) : Colors.grey[400],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Deactivate Dialog
// ─────────────────────────────────────────────
class _DeactivateDialog extends StatefulWidget {
  final SlotModel slot;
  final ValueChanged<String> onConfirm;

  const _DeactivateDialog({required this.slot, required this.onConfirm});

  @override
  State<_DeactivateDialog> createState() => _DeactivateDialogState();
}

class _DeactivateDialogState extends State<_DeactivateDialog> {
  final _controller = TextEditingController();
  bool _hasError = false;
  String? _selectedReason;

  final List<String> _quickReasons = [
    'Maintenance work',
    'Property unavailable',
    'Owner personal use',
    'Emergency closure',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon + Title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.pause_circle_outline_rounded,
                    color: Color(0xFFE65100),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Deactivate Slot',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1B2D1F),
                        ),
                      ),
                      Text(
                        'This will hide the slot from users',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF74A98E),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Slot Info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FBF4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFB7E4C7)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    size: 16,
                    color: Color(0xFF2D6A4F),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${widget.slot.duration}  •  ${widget.slot.timeRange}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D6A4F),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Quick Reasons
            const Text(
              'Quick reasons',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF5A7A65),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _quickReasons.map((r) {
                final selected = _selectedReason == r;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedReason = r;
                      _controller.text = r;
                      _hasError = false;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFF2D6A4F)
                          : const Color(0xFFF0FBF4),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected
                            ? const Color(0xFF2D6A4F)
                            : const Color(0xFFB7E4C7),
                      ),
                    ),
                    child: Text(
                      r,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: selected
                            ? Colors.white
                            : const Color(0xFF2D6A4F),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),

            // Custom Reason Field
            const Text(
              'Or enter a custom reason',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF5A7A65),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _controller,
              maxLines: 3,
              onChanged: (_) => setState(() {
                _hasError = false;
                _selectedReason = null;
              }),
              style: const TextStyle(fontSize: 14, color: Color(0xFF1B2D1F)),
              decoration: InputDecoration(
                hintText: 'Describe why you\'re deactivating this slot...',
                hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
                errorText: _hasError ? 'Please enter a reason' : null,
                filled: true,
                fillColor: const Color(0xFFF9FEFB),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFB7E4C7)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFB7E4C7)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF2D6A4F),
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.red, width: 1.5),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 20),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: const BorderSide(
                        color: Color(0xFFB7E4C7),
                        width: 1.5,
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color(0xFF5A7A65),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_controller.text.trim().isEmpty) {
                        setState(() => _hasError = true);
                        return;
                      }
                      widget.onConfirm(_controller.text.trim());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC62828),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Deactivate',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
