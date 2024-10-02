// To parse this JSON data, do
//
//     final contactList = contactListFromJson(jsonString);

import 'dart:convert';

ContactList contactListFromJson(String str) =>
    ContactList.fromJson(json.decode(str));

String contactListToJson(ContactList data) => json.encode(data.toJson());

class ContactList {
  List<Datum>? data;
  Links? links;
  Meta? meta;

  ContactList({
    this.data,
    this.links,
    this.meta,
  });

  factory ContactList.fromJson(Map<String, dynamic> json) => ContactList(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        links: json["links"] == null ? null : Links.fromJson(json["links"]),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "links": links?.toJson(),
        "meta": meta?.toJson(),
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
  int? unreadMessages;

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
    this.unreadMessages,
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
        unreadMessages: json["unread_messages"],
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
        "unread_messages": unreadMessages,
      };
}

class Links {
  String? first;
  String? last;
  dynamic prev;
  String? next;

  Links({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  factory Links.fromJson(Map<String, dynamic> json) => Links(
        first: json["first"],
        last: json["last"],
        prev: json["prev"],
        next: json["next"],
      );

  Map<String, dynamic> toJson() => {
        "first": first,
        "last": last,
        "prev": prev,
        "next": next,
      };
}

class Meta {
  int? currentPage;
  int? from;
  int? lastPage;
  List<Link>? links;
  String? path;
  int? perPage;
  int? to;
  int? total;

  Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.links,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        currentPage: json["current_page"],
        from: json["from"],
        lastPage: json["last_page"],
        links: json["links"] == null
            ? []
            : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
        path: json["path"],
        perPage: json["per_page"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "from": from,
        "last_page": lastPage,
        "links": links == null
            ? []
            : List<dynamic>.from(links!.map((x) => x.toJson())),
        "path": path,
        "per_page": perPage,
        "to": to,
        "total": total,
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
