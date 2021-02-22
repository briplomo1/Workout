class ListNode:
        def __init__(self, val=0, next=None):
            self.val = val
            self.next = next


class LinkedList:
        def __init__(self):
            self.head = None

        def append(self, data):
            NewNode = ListNode(data)
            if self.head is None:
                self.head = NewNode
                return
            onNode = self.head
            while (onNode.next):
                onNode = onNode.next
            onNode.next = NewNode
        def __str__(self):
            return self.head
        def printList(self):
            current = self.head
            while current != None:
                print(current.val)
                current = current.next


def addTwoNumbers(l1, l2):
    
    new_l1 = str()
    new_l2 = str()
    
    while l1 != None:
        new_l1 = str(l1.val) + new_l1
        l1 = l1.next

    while l2 != None:
        new_l2 = str(l2.val) + new_l2
        l2 = l2.next

    reverse = str(int(new_l1) + int(new_l2))
    return createList(reverse)


def createList(string):
    newList = LinkedList()
    string = string[::-1]
    for char in string:
        print(char)
        print('Char')
        newList.append(char)
    return newList
        




    