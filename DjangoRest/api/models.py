from django.db.models.deletion import CASCADE
from unicodedata import name
from django.db import models
from django.contrib.auth.models import AbstractUser
from django.utils.translation import gettext_lazy as _
from django.conf import settings


class User(AbstractUser):
    username = models.CharField(blank=True, null=True, max_length=50)
    email = models.EmailField(_('email address'), unique=True)

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['username', 'first_name', 'last_name']

    def __str__(self):
        return self.email

    
        
class UserProfile(models.Model):
    user = models.OneToOneField(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='profile')
    date = models.DateTimeField(auto_now_add=True)
    dob = models.DateField()


class Exercise(models.Model):
    name = models.CharField( max_length=50, unique=True, primary_key=True)

    def __str__(self):
        return self.name


class Set(models.Model):
    owner = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, null=True, blank=True, related_name='sets')  
    date = models.DateTimeField(auto_now_add=True)
    reps = models.PositiveSmallIntegerField()
    weight = models.DecimalField(max_digits=10, decimal_places=2)

    def __str__(self):
        return self.exercise.name



class Workout(models.Model):
    owner = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='workouts')
    name = models.CharField(max_length=50, )
    date_created = models.DateField(auto_now_add=True, )

    def __str__(self):
        return self.name


class WorkoutSet(models.Model):
    setNum = models.PositiveSmallIntegerField()
    workout = models.ForeignKey(Workout, on_delete=models.CASCADE, related_name='workout_sets')
    # set to nullable after serializing is done
    exercise = models.ForeignKey(Exercise, on_delete=models.CASCADE, related_name='workout_sets')
    weight = models.DecimalField(max_digits=10, decimal_places=2)
    reps = models.PositiveSmallIntegerField()

    def __str__(self):
        return str(self.weight)
    