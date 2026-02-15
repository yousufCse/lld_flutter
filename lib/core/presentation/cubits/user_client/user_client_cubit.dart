/// Cubit for managing user client (tenant) state
/// Used for multi-tenant applications where UI needs to adapt
/// based on the active client/organization
class UserClientCubit {
  UserClientState _state = const UserClientState.undefined();

  UserClientState get state => _state;

  /// Set the active client for the current user
  void setClient(String clientId) {
    switch (clientId) {
      case 'niramoy':
        _state = const UserClientState.niramoy();
        break;
      case 'partner_a':
        _state = const UserClientState.partnerA();
        break;
      case 'partner_b':
        _state = const UserClientState.partnerB();
        break;
      default:
        _state = const UserClientState.niramoy();
        break;
    }
  }

  /// Reset to undefined state
  void resetClient() {
    _state = const UserClientState.undefined();
  }

  /// Get current client name
  String get currentClientName {
    return _state.when(
      undefined: () => 'Niramoy',
      niramoy: () => 'Niramoy',
      partnerA: () => 'Partner A',
      partnerB: () => 'Partner B',
    );
  }

  /// Get client-specific primary color
  String getClientColor() {
    return _state.when(
      undefined: () => '#1976D2', // Blue
      niramoy: () => '#1976D2', // Blue
      partnerA: () => '#2E7D32', // Green
      partnerB: () => '#7B1FA2', // Purple
    );
  }
}

/// User client state representing different tenants/organizations
class UserClientState {
  const UserClientState._(this.type);

  const UserClientState.undefined() : this._('undefined');
  const UserClientState.niramoy() : this._('niramoy');
  const UserClientState.partnerA() : this._('partner_a');
  const UserClientState.partnerB() : this._('partner_b');

  final String type;

  T when<T>({
    required T Function() undefined,
    required T Function() niramoy,
    required T Function() partnerA,
    required T Function() partnerB,
  }) {
    switch (type) {
      case 'undefined':
        return undefined();
      case 'niramoy':
        return niramoy();
      case 'partner_a':
        return partnerA();
      case 'partner_b':
        return partnerB();
      default:
        return undefined();
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserClientState && other.type == type;
  }

  @override
  int get hashCode => type.hashCode;
}
