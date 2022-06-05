from rest_framework import permissions

class IsAdminUser(permissions.BasePermission):
    
    def has_permission(self, request, view):
        return request.user and request.user.is_staff

    def has_object_permission(self, request, view, obj):
        return request.user and request.user.is_staff


class IsLoggedInUserOrAdmin(permissions.BasePermission):
    
    def has_object_permission(self, request, view, obj):
        return obj.owner == request.user or request.user.is_staff
            
        

class IsLoggedInUserOrAdminWS(permissions.BasePermission):
    def has_object_permission(self, request, view, obj):
        
        return obj.workout.owner == request.user

class IsOwner(permissions.BasePermission):
    '''
    Custom permission to only allow owners to read or edit
    '''
    def has_object_permission(self, request, view, obj):
        return request.user.profile == obj.owner


class IsUserOrAdmin(permissions.BasePermission):

    def has_object_permission(self, request, view, obj):
        return obj == request.user or request.user.is_staff

class CreateAndIsAuthenticated(permissions.IsAuthenticated):
    def has_permission(self, request, view):
        return (view.action == 'create'
                and super(CreateAndIsAuthenticated, self).has_permission(request, view))

class NotCreateAndIsAdminUser(permissions.IsAdminUser):
    def has_permission(self, request, view):
        return (view.action in ['update', 'partial_update', 'destroy', 'list'] 
                and super(NotCreateAndIsAdminUser, self).has_permission(request, view))

