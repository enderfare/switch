@startuml
title Switch Application - Entity Relationship Diagram

' ===== ENTITIES =====
entity User {
  * id: String <<PK>>
  --
  name: String
  surname: String
  email: String <<UNIQUE>>
  password: String
  avatar: String
  created_at: Timestamp
  updated_at: Timestamp
  last_login: Timestamp
  is_active: Boolean
}

entity Board {
  * id: String <<PK>>
  --
  name: String
  description: Text
  color: String
  icon: String
  created_date: Timestamp
  updated_date: Timestamp
  is_public: Boolean
  is_archived: Boolean
  * owner_id: String <<FK>>
}

entity Section {
  * id: String <<PK>>
  --
  name: String
  description: Text
  type: String <<enum>> {NOTES, TASKS}
  created_date: Timestamp
  updated_date: Timestamp
  position: Integer
  is_collapsed: Boolean
  * board_id: String <<FK>>
  * created_by: String <<FK>>
}

entity NotesSection {
  * section_id: String <<PK>> <<FK>>
  --
  max_notes: Integer
  allow_markdown: Boolean
  default_note_type: String
  sort_by: String
}

entity TasksSection {
  * section_id: String <<PK>> <<FK>>
  --
  show_completed: Boolean
  sort_by: String <<enum>> {DUE_DATE, PRIORITY, CREATION_DATE, TITLE}
  default_priority: String <<enum>> {LOW, MEDIUM, HIGH, URGENT}
  allow_assignments: Boolean
  auto_archive: Boolean
}

entity Note {
  * id: String <<PK>>
  --
  title: String
  content: Text
  created_date: Timestamp
  modified_date: Timestamp
  tags: String[] <<array>>
  is_pinned: Boolean
  is_archived: Boolean
  version: Integer
  share_link: String
  is_shared: Boolean
  * section_id: String <<FK>>
  * author_id: String <<FK>>
  last_modified_by: String <<FK>>
}

entity NoteVersion {
  * id: String <<PK>>
  --
  title: String
  content: Text
  version: Integer
  modified_date: Timestamp
  * note_id: String <<FK>>
  * modified_by: String <<FK>>
}

entity Task {
  * id: String <<PK>>
  --
  title: String
  description: Text
  due_date: Timestamp
  created_date: Timestamp
  start_date: Timestamp
  completed: Boolean
  completed_date: Timestamp
  priority: String <<enum>> {LOW, MEDIUM, HIGH, URGENT}
  is_recurring: Boolean
  recurrence_pattern: String
  estimated_hours: Decimal(5,2)
  actual_hours: Decimal(5,2)
  * section_id: String <<FK>>
  * author_id: String <<FK>>
  parent_task_id: String <<FK>>
}

entity Comment {
  * id: String <<PK>>
  --
  content: Text
  created_date: Timestamp
  * task_id: String <<FK>>
  * user_id: String <<FK>>
}

entity Tag {
  * id: String <<PK>>
  --
  name: String <<UNIQUE>>
  color: String
}

' ===== RELATIONSHIPS =====

' User-Board relationships
User ||--o{ Board : owns
User }o--o{ Board : member_of
Board }o--o{ User : has_members

' Board-Section relationship
Board ||--o{ Section : contains
Section }|--|| Board : belongs_to

' Section specialization
Section }|--|| NotesSection : specialization
Section }|--|| TasksSection : specialization

' Section-Content relationships
NotesSection ||--o{ Note : contains
TasksSection ||--o{ Task : contains

Note }|--|| Section : belongs_to
Task }|--|| Section : belongs_to

' User-Content relationships
User ||--o{ Note : authors
User ||--o{ Task : creates
User }o--o{ Task : assigned_to

' Task relationships
Task }o--|| Task : parent_child
Task ||--o{ Comment : has

' Versioning
Note ||--o{ NoteVersion : has_versions
NoteVersion }|--|| Note : version_of

' Tagging relationships
Note }o--o{ Tag : tagged_with
Task }o--o{ Tag : tagged_with
Tag }o--o{ Note : tags
Tag }o--o{ Task : tags

' ===== WEAK ENTITIES =====
entity FriendRequest {
  * id: String <<PK>>
  --
  status: String <<enum>> {PENDING, ACCEPTED, DECLINED}
  sent_date: Timestamp
  * sender_id: String <<FK>>
  * receiver_id: String <<FK>>
}

entity BoardMember {
  * board_id: String <<PK>> <<FK>>
  * user_id: String <<PK>> <<FK>>
  --
  role: String <<enum>> {OWNER, ADMIN, EDITOR, VIEWER}
  joined_date: Timestamp
}

entity SectionPermission {
  * section_id: String <<PK>> <<FK>>
  * role: String <<PK>> <<enum>> {OWNER, ADMIN, EDITOR, VIEWER}
  --
  permission: String <<enum>> {READ, WRITE, DELETE, MANAGE}
}

entity NoteTag {
  * note_id: String <<PK>> <<FK>>
  * tag_id: String <<PK>> <<FK>>
  --
  created_date: Timestamp
}
' Friendship relationships
User }o--o{ User : friends_with
User ||--o{ FriendRequest : sends
User }o--|| FriendRequest : receives


entity TaskTag {
  * task_id: String <<PK>> <<FK>>
  * tag_id: String <<PK>> <<FK>>
  --
  created_date: Timestamp
}

entity TaskAssignment {
  * task_id: String <<PK>> <<FK>>
  * user_id: String <<PK>> <<FK>>
  --
  assigned_date: Timestamp
}

' ===== WEAK ENTITY RELATIONSHIPS =====
BoardMember }|--|| Board : member_of
BoardMember }|--|| User : is_member

SectionPermission }|--|| Section : has_permissions

NoteTag }|--|| Note : tagged
NoteTag }|--|| Tag : tag_applied
TaskTag }|--|| Task : tagged
TaskTag }|--|| Tag : tag_applied

TaskAssignment }|--|| Task : assigned
TaskAssignment }|--|| User : assignee

FriendRequest }|--|| User : sender
FriendRequest }|--|| User : receiver

' ===== ATTRIBUTE NOTES =====
note top of User
  Unique constraints:
  - email (unique)
end note

note top of Board
  Indexes:
  - owner_id
  - is_public
  - is_archived
end note

note top of Section
  Indexes:
  - board_id
  - position
  - type
end note

note top of Note
  Indexes:
  - section_id
  - author_id
  - is_pinned
  - created_date
end note

note top of Task
  Indexes:
  - section_id
  - author_id
  - due_date
  - priority
  - completed
  - parent_task_id
end note

note top of Tag
  Indexes:
  - name (unique)
end note

@enduml
