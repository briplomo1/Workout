
from django.http import request
from rest_framework import serializers
from .models import UserProfile, User, Set, Workout, WorkoutSet, Exercise


class ExerciseSerializer(serializers.ModelSerializer):
    class Meta:
        model = Exercise
        fields = ['name']
        


class WorkoutSetSerializer(serializers.ModelSerializer):
    
    #exercise = serializers.PrimaryKeyRelatedField(queryset=Exercise.objects.all())
    
    class Meta:
        model = WorkoutSet
        fields = ['id','reps','exercise','weight', 'setNum',]

    
    # def create(self, validated_data,):

    #     exercise_data = validated_data.pop('exercise')
    #     print(exercise_data)
    #     ex = Exercise.objects.get(name="Squat")
    #     workoutSet = super().create(exercise=ex.name, )
         
    #     print('create')
        
    #     workoutSet.save()
    #     return workoutSet
        
        

class WorkoutSerializer(serializers.HyperlinkedModelSerializer):
    workout_sets = WorkoutSetSerializer(required=False,many=True)
    class Meta:
        
        model = Workout
        fields = ['url','owner', 'name', 'date_created', 'workout_sets']
        read_only_fields = ['owner', 'date_created']

    def create(self, validated_data):
        print(validated_data)
        workout_sets = validated_data.pop('workout_sets')
        workout_instance = Workout.objects.create(**validated_data)
        for set in workout_sets:
            ex = set.pop('exercise')
            print(ex)
            wset_instance = WorkoutSet.objects.create(workout=workout_instance, exercise=ex, **set)
            wset_instance.save()
        workout_instance.save()
        return workout_instance


class SetSerializer(serializers.ModelSerializer):
    #owner = serializers.HyperlinkedRelatedField(view_name='user-detail', read_only=True,)
    exercise = ExerciseSerializer(read_only=True)
    class Meta:
        model = Set
        fields = ['url', 'owner', 'date', 'reps', 'weight', 'exercise'] 


class UserProfileSerializer(serializers.ModelSerializer):
    class Meta:
            model = UserProfile
            fields = ['dob']


class UserSerializer(serializers.ModelSerializer):
    profile = UserProfileSerializer(required=False)
    sets = SetSerializer(many=True, required=False, read_only=True)
    workouts = WorkoutSerializer(many=True, required=False, read_only=True)

    class Meta:
        model = User
        fields = ('id', 'email', 'first_name', 'last_name', 'password', 'profile', 'sets', 'workouts')
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        profile_data = validated_data.pop('profile')
        password = validated_data.pop('password')
        user = User(**validated_data)
        user.set_password(password)
        user.save()
        UserProfile.objects.create(user=user, **profile_data)
        return user

    def update(self, instance, validated_data):
        profile_data = validated_data.pop('profile')
        profile = instance.profile

        instance.email = validated_data.get('email', instance.email)
        instance.save()

        profile.dob = profile_data.get('dob', profile.dob)
        profile.save()

        return instance





        