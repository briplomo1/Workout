from django.urls import path, include
from . import views
from rest_framework import routers
from rest_framework_simplejwt import views as jwt_views

router = routers.DefaultRouter()
router.register(r'users', views.UserViewSet, basename='user')
router.register(r'sets', views.SetsViewSet, basename='set')
router.register(r'workouts', views.WorkoutsViewSet, basename='workout')
router.register(r'workout_sets', views.WorkoutSetsViewSet, basename = 'workout_Sets')
router.register(r'exercises', views.ExerciseViewSet, basename='exercises')
urlpatterns = [
    path('', include(router.urls)),
    path('token/', jwt_views.TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('token/refresh/', jwt_views.TokenRefreshView.as_view(), name='token_refresh'),
]


