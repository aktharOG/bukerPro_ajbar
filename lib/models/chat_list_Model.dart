// To parse this JSON data, do
//
//     final chatListModel = chatListModelFromJson(jsonString);

import 'dart:convert';

ChatListModel chatListModelFromJson(String str) =>
    ChatListModel.fromJson(json.decode(str));

String chatListModelToJson(ChatListModel data) => json.encode(data.toJson());

class ChatListModel {
  String? status;
  Data? data;
  Organization? organization;
  int? unassigned;
  int? closed;
  int? all;

  ChatListModel({
    this.status,
    this.data,
    this.organization,
    this.unassigned,
    this.closed,
    this.all,
  });

  factory ChatListModel.fromJson(Map<String, dynamic> json) => ChatListModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        organization: json["organization"] == null
            ? null
            : Organization.fromJson(json["organization"]),
        unassigned: json["unassigned"],
        closed: json["closed"],
        all: json["all"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "organization": organization?.toJson(),
        "unassigned": unassigned,
        "closed": closed,
        "all": all,
      };
}

class Data {
  int? currentPage;
  List<Datum>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link>? links;
  dynamic nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  Data({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        currentPage: json["current_page"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: json["links"] == null
            ? []
            : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": links == null
            ? []
            : List<dynamic>.from(links!.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class Datum {
  int? id;
  String? uuid;
  int? organizationId;
  String? firstName;
  String? lastName;
  String? phone;
  dynamic email;
  DateTime? latestChatCreatedAt;
  dynamic avatar;
  dynamic address;
  dynamic metadata;
  dynamic contactGroupId;
  int? isFavorite;
  int? aiAssistanceEnabled;
  int? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  String? fullName;
  String? formattedPhoneNumber;

  Datum({
    this.id,
    this.uuid,
    this.organizationId,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.latestChatCreatedAt,
    this.avatar,
    this.address,
    this.metadata,
    this.contactGroupId,
    this.isFavorite,
    this.aiAssistanceEnabled,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.fullName,
    this.formattedPhoneNumber,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        uuid: json["uuid"],
        organizationId: json["organization_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        phone: json["phone"],
        email: json["email"],
        latestChatCreatedAt: json["latest_chat_created_at"] == null
            ? null
            : DateTime.parse(json["latest_chat_created_at"]),
        avatar: json["avatar"],
        address: json["address"],
        metadata: json["metadata"],
        contactGroupId: json["contact_group_id"],
        isFavorite: json["is_favorite"],
        aiAssistanceEnabled: json["ai_assistance_enabled"],
        createdBy: json["created_by"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        fullName: json["full_name"],
        formattedPhoneNumber: json["formatted_phone_number"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uuid": uuid,
        "organization_id": organizationId,
        "first_name": firstName,
        "last_name": lastName,
        "phone": phone,
        "email": email,
        "latest_chat_created_at": latestChatCreatedAt?.toIso8601String(),
        "avatar": avatar,
        "address": address,
        "metadata": metadata,
        "contact_group_id": contactGroupId,
        "is_favorite": isFavorite,
        "ai_assistance_enabled": aiAssistanceEnabled,
        "created_by": createdBy,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "full_name": fullName,
        "formatted_phone_number": formattedPhoneNumber,
      };
}

class Link {
  String? url;
  String? label;
  bool? active;

  Link({
    this.url,
    this.label,
    this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}

class Organization {
  int? id;
  String? uuid;
  String? identifier;
  String? name;
  dynamic address;
  String? metadata;
  dynamic timezone;
  int? createdBy;
  dynamic deletedAt;
  dynamic deletedBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  Organization({
    this.id,
    this.uuid,
    this.identifier,
    this.name,
    this.address,
    this.metadata,
    this.timezone,
    this.createdBy,
    this.deletedAt,
    this.deletedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Organization.fromJson(Map<String, dynamic> json) => Organization(
        id: json["id"],
        uuid: json["uuid"],
        identifier: json["identifier"],
        name: json["name"],
        address: json["address"],
        metadata: json["metadata"],
        timezone: json["timezone"],
        createdBy: json["created_by"],
        deletedAt: json["deleted_at"],
        deletedBy: json["deleted_by"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uuid": uuid,
        "identifier": identifier,
        "name": name,
        "address": address,
        "metadata": metadata,
        "timezone": timezone,
        "created_by": createdBy,
        "deleted_at": deletedAt,
        "deleted_by": deletedBy,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
