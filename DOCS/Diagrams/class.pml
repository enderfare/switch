@startuml

title Switch Application - Complete Class Diagram

package "betapoisoner.switch.models" {
class Role <<enum>> {
  ADMIN
  EDITOR
  VIEWER
  OWNER
}

class Priority <<enum>> {
  LOW
  MEDIUM
  HIGH
  URGENT
}

class Permission <<enum>> {
  READ
  WRITE
  DELETE
  MANAGE
}

class TaskSortOption <<enum>> {
  DUE_DATE
  PRIORITY
  CREATION_DATE
  TITLE
}

  class User {
    - id: String
    - name: String
    - surname: String
    - email: String
    - password: String
    - avatar: String
    - createdAt: Date
    - updatedAt: Date
    - lastLogin: Date
    - isActive: boolean
    - boards: Map<String, Board>
    - friends: List<User>
    - friendRequests: List<User>
    --
    + getId(): String
    + getFullName(): String
    + validatePassword(password: String): boolean
    + updateProfile(name: String, surname: String, email: String): void
    + changePassword(oldPassword: String, newPassword: String): boolean
    + addBoard(board: Board): void
    + removeBoard(boardId: String): boolean
    + addFriend(user: User): void
    + removeFriend(userId: String): boolean
    + sendFriendRequest(user: User): void
    + acceptFriendRequest(user: User): void
    + declineFriendRequest(user: User): void
    + getBoards(): List<Board>
    + getFriends(): List<User>
  }
  
  class Board {
    - id: String
    - name: String
    - description: String
    - color: String
    - icon: String
    - createdDate: Date
    - updatedDate: Date
    - isPublic: boolean
    - isArchived: boolean
    - sections: List<Section>
    - userRoles: Map<User, Role>
    - owner: User
    - invitedUsers: List<User>
    --
    + getId(): String
    + getName(): String
    + getDescription(): String
    + updateDetails(name: String, description: String): void
    + changeAppearance(color: String, icon: String): void
    + archive(): void
    + restore(): void
    + setVisibility(isPublic: boolean): void
    + addSection(section: Section): void
    + removeSection(sectionId: String): boolean
    + reorderSections(sectionOrder: List<String>): void
    + addUser(user: User, role: Role): void
    + removeUser(userId: String): boolean
    + updateUserRole(user: User, role: Role): void
    + inviteUser(user: User): void
    + revokeInvitation(userId: String): void
    + getSections(): List<Section>
    + getUsers(): List<User>
    + getUserRole(user: User): Role
  }
  
  abstract class Section {
    - id: String
    - name: String
    - description: String
    - createdDate: Date
    - updatedDate: Date
    - position: int
    - isCollapsed: boolean
    - permissions: Map<Role, Permission>
    - createdBy: User
    --
    + {abstract} getContent(): Object
    + {abstract} addContent(content: Object): boolean
    + {abstract} removeContent(contentId: String): boolean
    + {abstract} updateContent(contentId: String, content: Object): boolean
    + getId(): String
    + getName(): String
    + updateName(name: String): void
    + updateDescription(description: String): void
    + updatePosition(newPosition: int): void
    + toggleCollapse(): void
    + hasPermission(user: User, permission: Permission): boolean
    + getCreatedBy(): User
  }
  
  class NotesSection {
    - notes: List<Note>
    - maxNotes: int
    - allowMarkdown: boolean
    - defaultNoteType: String
    - sortBy: String
    - filterTags: List<String>
    --
    + addNote(note: Note): boolean
    + removeNote(noteId: String): boolean
    + updateNote(noteId: String, title: String, content: String): boolean
    + searchNotes(keyword: String): List<Note>
    + getNotesByTag(tag: String): List<Note>
    + getPinnedNotes(): List<Note>
    + sortNotes(sortBy: String): void
    + filterByTags(tags: List<String>): void
    + getNoteCount(): int
    + canAddNote(): boolean
  }
  
  class TasksSection {
    - tasks: List<Task>
    - completedTasks: List<Task>
    - showCompleted: boolean
    - sortBy: TaskSortOption
    - defaultPriority: Priority
    - allowAssignments: boolean
    - autoArchive: boolean
    --
    + addTask(task: Task): boolean
    + removeTask(taskId: String): boolean
    + updateTask(taskId: String, updates: Map<String, Object>): boolean
    + completeTask(taskId: String): boolean
    + uncompleteTask(taskId: String): boolean
    + getPendingTasks(): List<Task>
    + getOverdueTasks(): List<Task>
    + getCompletedTasks(): List<Task>
    + getTasksByPriority(priority: Priority): List<Task>
    + getTasksByUser(user: User): List<Task>
    + sortTasks(sortBy: TaskSortOption): void
    + toggleShowCompleted(): void
    + archiveCompletedTasks(): void
    + getTaskStatistics(): Map<String, Integer>
  }
  
  class Note {
    - id: String
    - title: String
    - content: String
    - createdDate: Date
    - modifiedDate: Date
    - author: User
    - lastModifiedBy: User
    - tags: List<String>
    - isPinned: boolean
    - isArchived: boolean
    - version: int
    - shareLink: String
    - isShared: boolean
    --
    + updateContent(newContent: String): void
    + updateTitle(newTitle: String): void
    + addTag(tag: String): void
    + removeTag(tag: String): void
    + containsText(search: String): boolean
    + togglePin(): void
    + archive(): void
    + restore(): void
    + share(): String
    + unshare(): void
    + getVersionHistory(): List<Note>
    + revertToVersion(version: int): boolean
    + getWordCount(): int
    + getCharacterCount(): int
  }
  
  class Task {
    - id: String
    - title: String
    - description: String
    - dueDate: Date
    - createdDate: Date
    - startDate: Date
    - completed: boolean
    - completedDate: Date
    - priority: Priority
    - author: User
    - assignedTo: List<User>
    - tags: List<String>
    - subtasks: List<Task>
    - parentTask: Task
    - isRecurring: boolean
    - recurrencePattern: String
    - estimatedHours: Double
    - actualHours: Double
    - comments: List<String>
    --
    + markComplete(): void
    + markIncomplete(): void
    + assignTo(user: User): void
    + unassignFrom(user: User): void
    + isOverdue(): boolean
    + updatePriority(priority: Priority): void
    + addTag(tag: String): void
    + removeTag(tag: String): void
    + addSubtask(task: Task): void
    + removeSubtask(taskId: String): boolean
    + getSubtasks(): List<Task>
    + setRecurrence(pattern: String): void
    + clearRecurrence(): void
    + logTime(hours: Double): void
    + addComment(comment: String): void
    + getComments(): List<String>
    + getProgress(): Double
  }
}

package "betapoisoner.switch.repositories" {
  interface UserRepository {
    + findByEmail(email: String): Optional<User>
    + findById(id: String): Optional<User>
    + findAll(): List<User>
    + save(user: User): User
    + deleteById(id: String): void
    + findByNameContainingOrSurnameContaining(name: String, surname: String): List<User>
    + findByIsActiveTrue(): List<User>
  }
  
  interface BoardRepository {
    + findById(id: String): Optional<Board>
    + findByOwner(owner: User): List<Board>
    + findByUserRolesContaining(user: User): List<Board>
    + save(board: Board): Board
    + deleteById(id: String): void
    + findByIsPublicTrue(): List<Board>
    + findByIsArchivedFalse(): List<Board>
  }
  
  interface SectionRepository {
    + findById(id: String): Optional<Section>
    + findByBoardId(boardId: String): List<Section>
    + save(section: Section): Section
    + deleteById(id: String): void
    + deleteByBoardId(boardId: String): void
  }
  
  interface NoteRepository {
    + findById(id: String): Optional<Note>
    + findBySectionId(sectionId: String): List<Note>
    + findByAuthor(author: User): List<Note>
    + save(note: Note): Note
    + deleteById(id: String): void
    + findByTagsContaining(tag: String): List<Note>
    + findByTitleContainingOrContentContaining(title: String, content: String): List<Note>
  }
  
  interface TaskRepository {
    + findById(id: String): Optional<Task>
    + findBySectionId(sectionId: String): List<Task>
    + findByAssignedTo(user: User): List<Task>
    + save(task: Task): Task
    + deleteById(id: String): void
    + findByCompletedFalseAndDueDateBefore(dueDate: Date): List<Task>
    + findByPriority(priority: Priority): List<Task>
  }
}

package "betapoisoner.switch.services" {
  class UserService {
    - userRepository: UserRepository
    - passwordEncoder: PasswordEncoder
    - jwtUtil: JwtUtil
    --
    + registerUser(userDto: UserDTO): User
    + authenticateUser(email: String, password: String): String
    + getUserById(id: String): User
    + updateUserProfile(id: String, userDto: UserDTO): User
    + changePassword(id: String, passwordChangeRequest: PasswordChangeRequest): boolean
    + searchUsers(query: String): List<User>
    + sendFriendRequest(fromUserId: String, toUserId: String): void
    + acceptFriendRequest(userId: String, requestId: String): void
    + removeFriend(userId: String, friendId: String): void
    + validateToken(token: String): boolean
  }
  
  class BoardService {
    - boardRepository: BoardRepository
    - userService: UserService
    - sectionService: SectionService
    --
    + createBoard(boardDto: BoardDTO, ownerId: String): Board
    + getBoardById(id: String): Board
    + getUserBoards(userId: String): List<Board>
    + updateBoard(id: String, boardDto: BoardDTO): Board
    + deleteBoard(id: String): void
    + addUserToBoard(boardId: String, userId: String, role: Role): Board
    + removeUserFromBoard(boardId: String, userId: String): Board
    + updateUserRole(boardId: String, userId: String, role: Role): Board
    + inviteUserToBoard(boardId: String, email: String): void
    + getBoardSections(boardId: String): List<Section>
  }
  
  class SectionService {
    - sectionRepository: SectionRepository
    - noteService: NoteService
    - taskService: TaskService
    --
    + createSection(sectionDto: SectionDTO, boardId: String, userId: String): Section
    + getSectionById(id: String): Section
    + updateSection(id: String, sectionDto: SectionDTO): Section
    + deleteSection(id: String): void
    + reorderSections(boardId: String, sectionOrder: List<String>): void
    + getSectionContent(sectionId: String): Object
  }
  
  class NoteService {
    - noteRepository: NoteRepository
    - sectionService: SectionService
    - userService: UserService
    --
    + createNote(noteDto: NoteDTO, sectionId: String, authorId: String): Note
    + getNoteById(id: String): Note
    + updateNote(id: String, noteDto: NoteDTO): Note
    + deleteNote(id: String): void
    + searchNotes(sectionId: String, query: String): List<Note>
    + getNotesByTag(sectionId: String, tag: String): List<Note>
    + shareNote(noteId: String): String
    + getNoteVersionHistory(noteId: String): List<Note>
  }
  
  class TaskService {
    - taskRepository: TaskRepository
    - sectionService: SectionService
    - userService: UserService
    --
    + createTask(taskDto: TaskDTO, sectionId: String, authorId: String): Task
    + getTaskById(id: String): Task
    + updateTask(id: String, taskDto: TaskDTO): Task
    + deleteTask(id: String): void
    + completeTask(id: String): Task
    + assignTask(taskId: String, userId: String): Task
    + getTasksByUser(userId: String): List<Task>
    + getOverdueTasks(): List<Task>
    + addSubtask(parentTaskId: String, taskDto: TaskDTO): Task
    + logTime(taskId: String, hours: Double): Task
  }
}

package "betapoisoner.switch.controllers" {
  class AuthController {
    - userService: UserService
    --
    + login(loginRequest: LoginRequest): ResponseEntity<AuthResponse>
    + register(registerRequest: RegisterRequest): ResponseEntity<AuthResponse>
    + refreshToken(refreshTokenRequest: RefreshTokenRequest): ResponseEntity<AuthResponse>
    + logout(): ResponseEntity<Void>
    + forgotPassword(forgotPasswordRequest: ForgotPasswordRequest): ResponseEntity<Void>
    + resetPassword(resetPasswordRequest: ResetPasswordRequest): ResponseEntity<Void>
  }
  
  class UserController {
    - userService: UserService
    --
    + getCurrentUser(): ResponseEntity<UserDTO>
    + updateProfile(userDTO: UserDTO): ResponseEntity<UserDTO>
    + changePassword(passwordChangeRequest: PasswordChangeRequest): ResponseEntity<Void>
    + searchUsers(query: String): ResponseEntity<List<UserDTO>>
    + sendFriendRequest(friendId: String): ResponseEntity<Void>
    + acceptFriendRequest(requestId: String): ResponseEntity<Void>
    + removeFriend(friendId: String): ResponseEntity<Void>
  }
  
  class BoardController {
    - boardService: BoardService
    --
    + getAllBoards(): ResponseEntity<List<BoardDTO>>
    + createBoard(boardDTO: BoardDTO): ResponseEntity<BoardDTO>
    + getBoard(id: String): ResponseEntity<BoardDTO>
    + updateBoard(id: String, boardDTO: BoardDTO): ResponseEntity<BoardDTO>
    + deleteBoard(id: String): ResponseEntity<Void>
    + addUserToBoard(id: String, userRequest: AddUserRequest): ResponseEntity<BoardDTO>
    + removeUserFromBoard(id: String, userId: String): ResponseEntity<BoardDTO>
    + updateUserRole(id: String, userRoleRequest: UserRoleRequest): ResponseEntity<BoardDTO>
  }
  
  class SectionController {
    - sectionService: SectionService
    --
    + createSection(boardId: String, sectionDTO: SectionDTO): ResponseEntity<SectionDTO>
    + updateSection(id: String, sectionDTO: SectionDTO): ResponseEntity<SectionDTO>
    + deleteSection(id: String): ResponseEntity<Void>
    + reorderSections(boardId: String, reorderRequest: ReorderRequest): ResponseEntity<Void>
  }
  
  class NoteController {
    - noteService: NoteService
    --
    + createNote(sectionId: String, noteDTO: NoteDTO): ResponseEntity<NoteDTO>
    + updateNote(id: String, noteDTO: NoteDTO): ResponseEntity<NoteDTO>
    + deleteNote(id: String): ResponseEntity<Void>
    + searchNotes(sectionId: String, query: String): ResponseEntity<List<NoteDTO>>
    + shareNote(id: String): ResponseEntity<ShareResponse>
    + getVersionHistory(id: String): ResponseEntity<List<NoteDTO>>
  }
  
  class TaskController {
    - taskService: TaskService
    --
    + createTask(sectionId: String, taskDTO: TaskDTO): ResponseEntity<TaskDTO>
    + updateTask(id: String, taskDTO: TaskDTO): ResponseEntity<TaskDTO>
    + deleteTask(id: String): ResponseEntity<Void>
    + completeTask(id: String): ResponseEntity<TaskDTO>
    + assignTask(id: String, assignRequest: AssignRequest): ResponseEntity<TaskDTO>
    + addSubtask(id: String, taskDTO: TaskDTO): ResponseEntity<TaskDTO>
    + logTime(id: String, timeLogRequest: TimeLogRequest): ResponseEntity<TaskDTO>
  }
}

package "betapoisoner.switch.security" {
  class JwtUtil {
    - secretKey: String
    - expirationTime: Long
    --
    + generateToken(user: User): String
    + extractUsername(token: String): String
    + extractExpiration(token: String): Date
    + validateToken(token: String, user: User): boolean
    + isTokenExpired(token: String): boolean
  }
  
  class JwtAuthenticationFilter {
    - jwtUtil: JwtUtil
    - userService: UserService
    --
    + doFilterInternal(request: HttpServletRequest, response: HttpServletResponse, filterChain: FilterChain): void
  }
  
  class SecurityConfig {
    - jwtAuthenticationFilter: JwtAuthenticationFilter
    --
    + configure(http: HttpSecurity): void
    + passwordEncoder(): PasswordEncoder
  }
}

package "betapoisoner.switch.websocket" {
  class WebSocketConfig {
    + configureMessageBroker(registry: MessageBrokerRegistry): void
    + registerStompEndpoints(registry: StompEndpointRegistry): void
  }
  
  class BoardWebSocketHandler {
    - boardService: BoardService
    - userService: UserService
    --
    + handleBoardUpdate(boardId: String, update: BoardUpdate): void
    + handleSectionUpdate(boardId: String, sectionId: String, update: SectionUpdate): void
    + handleNoteUpdate(sectionId: String, noteId: String, update: NoteUpdate): void
    + handleTaskUpdate(sectionId: String, taskId: String, update: TaskUpdate): void
    + sendUserJoined(boardId: String, user: User): void
    + sendUserLeft(boardId: String, user: User): void
  }
}

package "betapoisoner.switch.dto" {
  class UserDTO {
    - id: String
    - name: String
    - surname: String
    - email: String
    - avatar: String
    - friendCount: int
    - boardCount: int
  }
  
  class BoardDTO {
    - id: String
    - name: String
    - description: String
    - color: String
    - icon: String
    - isPublic: boolean
    - userCount: int
    - sectionCount: int
  }
  
  class SectionDTO {
    - id: String
    - name: String
    - description: String
    - type: String
    - position: int
    - boardId: String
  }
  
  class NoteDTO {
    - id: String
    - title: String
    - content: String
    - tags: List<String>
    - isPinned: boolean
    - author: UserDTO
  }
  
  class TaskDTO {
    - id: String
    - title: String
    - description: String
    - dueDate: Date
    - priority: Priority
    - assignedTo: List<UserDTO>
    - tags: List<String>
  }
}

' === MODEL RELATIONSHIPS ===
Section <|-- NotesSection
Section <|-- TasksSection
User *-- Board : owns
Board *-- Section : contains
NotesSection *-- Note : contains
TasksSection *-- Task : contains
User "1" -- "0..*" User : friends
Board "1" o-- "0..*" User : shared with\nvia userRoles
User "1" -- "0..*" Note : authors
User "1" -- "0..*" Task : creates
Task "0..*" -- "0..*" User : assigned to
Task "0..1" -- "0..*" Task : subtasks
Task "0..1" -- "0..1" Task : parent task

' === REPOSITORY DEPENDENCIES ===
UserRepository ..> User
BoardRepository ..> Board
SectionRepository ..> Section
NoteRepository ..> Note
TaskRepository ..> Task

' === SERVICE DEPENDENCIES ===
UserService --> UserRepository
UserService --> JwtUtil
BoardService --> BoardRepository
BoardService --> UserService
BoardService --> SectionService
SectionService --> SectionRepository
SectionService --> NoteService
SectionService --> TaskService
NoteService --> NoteRepository
NoteService --> SectionService
NoteService --> UserService
TaskService --> TaskRepository
TaskService --> SectionService
TaskService --> UserService

' === CONTROLLER DEPENDENCIES ===
AuthController --> UserService
UserController --> UserService
BoardController --> BoardService
SectionController --> SectionService
NoteController --> NoteService
TaskController --> TaskService

' === SECURITY DEPENDENCIES ===
JwtAuthenticationFilter --> JwtUtil
JwtAuthenticationFilter --> UserService
SecurityConfig --> JwtAuthenticationFilter

' === WEBSOCKET DEPENDENCIES ===
BoardWebSocketHandler --> BoardService
BoardWebSocketHandler --> UserService

' === DTO MAPPINGS ===
UserDTO ..> User
BoardDTO ..> Board
SectionDTO ..> Section
NoteDTO ..> Note
TaskDTO ..> Task

' === ENUM DEPENDENCIES ===
Section --> Role
Board --> User
Section --> Permission
Task --> Priority
TasksSection --> TaskSortOption

@enduml