from rest_framework import permissions, viewsets
from .permissions import *
from .models import User, Set, Workout, WorkoutSet, Exercise
from .serializers import  ExerciseSerializer, UserSerializer, SetSerializer, UserProfileSerializer, WorkoutSerializer, WorkoutSetSerializer


class ExerciseViewSet(viewsets.ModelViewSet):
    serializer_class = ExerciseSerializer
    queryset = Exercise.objects.all()

    def get_permissions(self):
        permission_classes=[]
        if self.action in ['update', 'partial-update', 'destroy', 'create']:
            permission_classes = [IsAdminUser]
        elif self.action in ['list', 'retrieve']:
            permission_classes = [permissions.IsAuthenticated]
        return [permission() for permission in permission_classes]   

class UserViewSet(viewsets.ModelViewSet):
    serializer_class = UserSerializer
    queryset = User.objects.all()

    def get_permissions(self):
        permission_classes = []
        if self.action == 'create':
            permission_classes = [permissions.AllowAny]
        elif self.action in['update', 'partial-update', 'retrieve']:
            permission_classes = [IsUserOrAdmin]
        elif self.action == 'list' or self.action == 'destroy':
            permission_classes = [IsAdminUser]
        return [permission() for permission in permission_classes]

class WorkoutSetsViewSet(viewsets.ModelViewSet):
    serializer_class = WorkoutSetSerializer
    queryset = WorkoutSet.objects.all()

    def get_permissions(self):
        permission_classes= []
        if self.action == 'create':
            permission_classes = [permissions.IsAuthenticated]
        elif self.action in ['retrieve', 'update', 'partial-update', 'destroy']:
            permission_classes = [IsUserOrAdmin]
        elif self.action == 'list':
            permission_classes = [IsAdminUser]
        return [permission() for permission in permission_classes]


    

class SetsViewSet(viewsets.ModelViewSet):
    serializer_class = SetSerializer
    queryset = Set.objects.all()
    
    def get_permissions(self):
        permission_classes = []
        if self.action == 'create':
            permission_classes = [permissions.IsAuthenticated]
        elif self.action in ['retrieve', 'update', 'partial_update', 'destroy']:
            permission_classes = [IsLoggedInUserOrAdmin]
        elif self.action == 'list':
            permission_classes = [IsAdminUser]
        return [permission() for permission in permission_classes]

    

    def perform_create(self, serializer):
        serializer.save(owner=self.request.user)


class WorkoutsViewSet(viewsets.ModelViewSet):
    serializer_class = WorkoutSerializer
    queryset = Workout.objects.all()

    def get_permissions(self):
        permission_classes = []
        if self.action == 'create':
            permission_classes = [permissions.IsAuthenticated]
        elif self.action in ['retrieve', 'update', 'partial_update', 'destroy']:
            permission_classes = [IsLoggedInUserOrAdmin]
        elif self.action == 'list':
            permission_classes = [IsAdminUser]
        return [permission() for permission in permission_classes]

    def perform_create(self, serializer):
        print(self.request.data)
        serializer.save(owner = self.request.user)
