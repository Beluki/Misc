#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
ThreadPool.
Threads, immediate feedback and KeyboardInterrupt.
"""


import queue
import time

from multiprocessing import cpu_count
from queue import Queue
from threading import Thread


class Worker(Thread):
    """
    Thread that pops tasks from a '.todo' Queue, executes them, and puts
    the completed tasks in a '.done' Queue.

    A task is any object that has a run() method.
    Tasks themselves are responsible to hold their own results.
    """

    def __init__(self, todo, done):
        super().__init__()
        self.todo = todo
        self.done = done
        self.daemon = True
        self.start()

    def run(self):
        while True:
            task = self.todo.get()
            task.run()
            self.done.put(task)
            self.todo.task_done()


def fib(n):
    if n < 2:
        return 1
    else:
        return fib(n - 1) + fib(n - 2)


class FibTask(object):
    """
    A task that calculates fibonacci numbers
    storing the result in itself.
    """

    def __init__(self, number):
        self.number = number

    def run(self):
        self.result = fib(self.number)


class ThreadPool(object):
    """
    Mantains a list of 'todo' and 'done' tasks and a number of threads
    consuming the tasks. Child threads are expected to put the tasks
    in the 'done' queue when those are completed.
    """

    def __init__(self, threads):
        self.threads = threads

        self.tasks = []
        self.results = set()

        self.todo = Queue()
        self.done = Queue()

    def start(self, tasks):
        """ Start computing tasks. """
        self.tasks = tasks

        for task in self.tasks:
            self.todo.put(task)

        for x in range(self.threads):
            Worker(self.todo, self.done)

    def wait_for_task(self):
        """ Wait for one task to complete. """
        while True:
            try:
                task = self.done.get(block = False)
                self.results.add(task)
                break

            # give tasks processor time:
            except queue.Empty:
                time.sleep(0.1)

    def poll_completed_tasks(self):
        """
        Yield the computed tasks, in the order specified when 'start(tasks)'
        was called, as soon as they are finished.
        """
        for task in self.tasks:
            while True:
                if task in self.results:
                    yield task
                    break
                else:
                    self.wait_for_task()

        # at this point, all the tasks are completed:
        self.todo.join()


# Entry point:

def main():
    cpus = cpu_count()
    pool = ThreadPool(cpus)

    tasks = [FibTask(n) for n in range(1, 33)]
    tasks += [FibTask(n) for n in reversed(range(1, 33))]

    pool.start(tasks)

    # should print the results in order
    # first from 1 to 32, then from 32 to 1:
    for task in pool.poll_completed_tasks():
        print('fib(%s): %s' % (task.number, task.result), flush = True)


if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        pass

